local count = 0

local core = require"core"
dofile "lua/Pulsar/OI.lua"
dofile "lua/Pulsar/RobotMap.lua"
local Scheduler = require"command.Scheduler"
require("mqtt_lua_console").start()

core.setCompositeRobot()

Robot.scheduler = Scheduler()

Robot.Teleop.Put("Drive",{
    Initialize = function()
      print"TeleopInit"
    end,
    Execute = function()
      Robot.drive:MecanumDrive_Cartesian(OI.DriveX:Get(), OI.DriveY:Get(), OI.DriveTheta:Get())
      --Robot.drive:TankDrive(Robot.joy:GetRawAxis(1), Robot.joy:GetRawAxis(3))
      if count % 50 == 0 then
        print("BLTalon voltage: "..tostring(robotMap.BLTalon:GetOutputVoltage()).." current: "..tostring(robotMap.BLTalon:GetOutputCurrent()))
      end
      count = count + 1
    end,
    End = function()
      Robot.drive:MecanumDrive_Cartesian(0, 0, 0)
    end
  })
--print( robotMap.BLTalon, robotMap.FLTalon, robotMap.FRTalon, robotMap.BRTalon)
Robot.drive = WPILib.RobotDrive(robotMap.BLTalon, robotMap.FLTalon, robotMap.FRTalon, robotMap.BRTalon)

Robot.drive:SetSafetyEnabled(false)

Robot.drive:SetInvertedMotor(0, true)
Robot.drive:SetInvertedMotor(1, true)
Robot.drive:SetInvertedMotor(2, true)
Robot.drive:SetInvertedMotor(3, true)

Robot.Teleop.Put("Scheduler",Robot.scheduler)

dofile "lua/Pulsar/pulsarIntake.lua"