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
      local recv = arduino:read("*n")
      updateEMA(recv)
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