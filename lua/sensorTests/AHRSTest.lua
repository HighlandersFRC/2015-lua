local core = require"core"
serial = WPILib.SerialPort(57600, 1)
local ahrs = WPILib.AHRS(serial, 50)
core.setBasicRobot()
serial = nil
local updateCount = 0
collectgarbage()

Robot.Disabled = {
  Execute = function()
    if updateCount % 100 == 0 then
      --print(("heading: {yaw=%f, pitch=%f, roll=%f}"):format(ahrs:GetYaw(), ahrs:GetPitch(), ahrs:GetRoll()))
      print(("acceleration: {x=%f, y=%f, z=%f}"):format(ahrs:GetWorldLinearAccelX(), ahrs:GetWorldLinearAccelY(), ahrs:GetWorldLinearAccelZ()))
      print(("velocity: {x=%f, y=%f}"):format(ahrs:GetVelocityX(), ahrs:GetVelocityY()))
      print(("displacement: {x=%f, y=%f}"):format(ahrs:GetDisplacementX(), ahrs:GetDisplacementY()))
    end
    updateCount = updateCount+1
  end
}
