local core = require"core"
local lanes = require"lanes"
lanes.configure({with_timers=false})
local linda = lanes.linda()
local laneGen = lanes.gen("io,string,os",   function()
    local alpha = 0.5
    local emaVal = 0
    local lastFragment = ""
    local arduino = io.open"/dev/ttyACM0"
    local lastRecievedTime = os.time()
    local missingData = false
    local function updateEMA(val)
      lastRecievedTime = os.time()
      if missingData then
        local msg = "lidar has recieved a new value"
        io.write("\n=="..("="):rep(#msg).."==\n=="..msg.."==\n=="..("="):rep(#msg).."==\n")
        missingData = false
      end
      emaVal = alpha * val + (1-alpha)*emaVal
      linda:set("lidar",emaVal)
    end
    while true do

      local recv = arduino:read(5)
      -- print(recv)

      local offset = recv:find("\n")
      -- print(1)
      local newVal = tonumber(lastFragment..recv:sub(1, offset))
      -- print(2)
      if newVal then
        if newVal == 0 then
          newVal = 4096
        end
        updateEMA(newVal)
      end
      -- print(3)
      local prevOffset = offset
      --print(4)
      offset = recv:find("\n")
      -- print(5)
      while offset ~= nil do
        --print("trying substr", recv:sub(prevOffset+1, offset), "giving", tonumber(recv:sub(prevOffset+1, offset)))
        newVal = tonumber(recv:sub(prevOffset+1, offset))
        --print("newVal", newVal)
        if newVal then
          if newVal == 0 then
            newVal = 4096
          end
          updateEMA(newVal)
        end
        prevOffset = offset
        offset = recv:find("\n", offset+1)
      end
      --print(6)
      lastFragment = recv:sub(prevOffset+1, -1)
      if lastRecievedTime + 0.2 <= os.time() then
        missingData = true
        local msg = "lidar has not recieved a value for "..(os.time() - lastRecievedTime).." seconds"
        io.write("\n=="..("="):rep(#msg).."==\n=="..msg.."==\n=="..("="):rep(#msg).."==\n")
      end
    end
  end)


local lidar = {}
local lastFragment = ""


function lidar:Get()
  local val = linda:get("lidar")
  print("lidar returned", val)
  return val

end
print("pcall of lanegen",pcall(laneGen))

return lidar