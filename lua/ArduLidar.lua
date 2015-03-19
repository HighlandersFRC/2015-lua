local core = require"core"
local lanes = require"lanes"
lanes.configure()
local linda = lanes.linda()
local laneGen = lanes.gen("io", "string",  function()
    local alpha = 0.5
    local emaVal = 0
    local lastFragment = ""
    local arduino = io.open"/dev/ttyACM0"
    local function updateEMA(val)
      emaVal = alpha * val + (1-alpha)*emaVal
      linda:set("lidar",emaVal)
    end
    while true do

      local recv = arduino:read(32)
      -- print(recv)

      local offset = recv:find("\n")
      -- print(1)
      local newVal = tonumber(lastFragment..recv:sub(1, offset))
      -- print(2)
      if newVal then
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
        if newVal then
          updateEMA(newVal)
        end
        prevOffset = offset
        offset = recv:find("\n", offset+1)
      end
      --print(6)
      lastFragment = recv:sub(prevOffset+1, -1)

    end
  end)


local lidar = {}
local lastFragment = ""


function lidar:Get()
  print(linda:get("lidar"))
  return linda:get("lidar")
end
laneGen()

return lidar