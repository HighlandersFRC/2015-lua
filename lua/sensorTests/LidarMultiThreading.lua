local core = require"core"
local lidar = require"ArduLidar"
core.setBasicRobot()
local updateCount = 0

Robot.Disabled = {
  Execute = function()
    if updateCount % 100 == 0 then
      print(lidar:Get())
      
    end
    updateCount = updateCount+1
  end
}
