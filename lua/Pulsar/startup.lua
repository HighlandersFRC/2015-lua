print"getting timestamp"
print("timestamp: ", WPILib.Timer.GetFPGATimestamp())
print("WPILib", WPILib)
print("WPILib.Timer", WPILib.Timer)
print("WPILib.Timer.GetFPGATimestamp", WPILib.Timer.GetFPGATimestamp)
print("metatable", getmetatable(WPILib.Timer))

WPILib_backup = WPILib

function checkWPILib(location)
  if WPILib == WPILib_backup then
    debugPrint("WPILib is ok at "..location)
  else
    debugPrint("WPILib is BAD at "..location)
  end
end

local count = 0

print"beginning requires"
--require"WPILib"
--print"required WPILib"
local core = require"core"
print"required core"
require"Pulsar.OI"
print"required OI"
require"Pulsar.RobotMap"
print"required RobotMap"
local Scheduler = require"command.Scheduler"
print"requires finished"
--require("mqtt_lua_console").start()
checkWPILib("requires")

core.setCompositeRobot()

Robot.scheduler = Scheduler()
Robot.schedulerAuto = Scheduler()

checkWPILib("schedulers")

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
checkWPILib("driveAction")
--print( robotMap.BLTalon, robotMap.FLTalon, robotMap.FRTalon, robotMap.BRTalon)
Robot.drive = WPILib.RobotDrive(robotMap.BLTalon, robotMap.FLTalon, robotMap.FRTalon, robotMap.BRTalon)

Robot.drive:SetSafetyEnabled(false)

Robot.drive:SetInvertedMotor(0, true)
Robot.drive:SetInvertedMotor(1, true)
Robot.drive:SetInvertedMotor(2, true)
Robot.drive:SetInvertedMotor(3, true)
checkWPILib"drive setup"

Robot.Teleop.Put("Scheduler",Robot.scheduler)
Robot.Autonomous.Put("Autonomous", require"Pulsar.Auto.AutonomousStartup")
checkWPILib"Put Schedulers"

dofile "lua/Pulsar/pulsarIntake.lua"

checkWPILib"end"
print("WPILib", WPILib)
print("WPILib.Timer", WPILib.Timer)
print("WPILib.Timer.GetFPGATimestamp", WPILib.Timer.GetFPGATimestamp)