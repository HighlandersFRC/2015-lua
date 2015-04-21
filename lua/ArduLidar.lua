local core = require"core"
local lanes = require"lanes"
lanes.configure({with_timers=false})
local linda = lanes.linda()
local laneGen = lanes.gen("io,string,os",   function()
<<<<<<< HEAD
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
=======
    print(pcall(function()
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
            local recv
            if arduino then
              recv = arduino:read("*n")
            end
            --print("[ArduLidar] raw lidar read: "..tostring(recv))
            if recv ~= nil then
              updateEMA(recv)
            else
              if arduino then
                arduino:close()
              end
              arduino = io.open"/dev/ttyACM0"
            end
          end
        end
        ))
    end)
>>>>>>> cc2a79e0c148be58e6b7358ea08791af642ef739


  local lidar = {}
  local lastFragment = ""


<<<<<<< HEAD


=======
<<<<<<< HEAD
>>>>>>> cc2a79e0c148be58e6b7358ea08791af642ef739
function lidar:Get()
  local val = linda:get("lidar")
  --print("lidar returned", val)
  return val

end
--print("pcall of lanegen",pcall(laneGen))
=======
  function lidar:Get()
    local val = linda:get("lidar")
    --print("lidar returned", val)
    return val

  end
  print("pcall of lanegen",pcall(laneGen))
>>>>>>> e2fd0c53193808b4ce198a2f2e1d3eecf2ce323e

  return lidar
