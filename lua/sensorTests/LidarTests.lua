local core = require"core"
serial = WPILib.SerialPort(57600, 1)
local ahrs = WPILib.AHRS(serial, 50)
core.setBasicRobot()
local updateCount = 0
local time = 0
local lastPrint = 0 
local lidarSensor = WPILib.LidarLiteI2C()
Robot.Disabled = {
  Execute = function()

    time = WPILib.Timer.GetFPGATimestamp() *1000
    if time > (lastPrint + 5) then
      print(time..", "..print("Robot/Lidar", lidarSensor:Get())..", "..ahrs:GetWorldLinearAccelY())
      lastPrint = time
    end
    
  end
}