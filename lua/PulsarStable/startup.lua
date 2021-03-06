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
require"PulsarStable.OI"
print"required OI"
require"PulsarStable.RobotMap"
print"required RobotMap"
require"PulsarStable.RobotConfig"
print"required RobotConfig"
local Scheduler = require"command.Scheduler"
print"requires finished"
local toggleSlow = false
local toggleTime = WPILib.Timer.GetFPGATimestamp()
local lidarSensor = WPILib.LidarLiteI2C()
--require("mqtt_lua_console").start()
checkWPILib("requires")
        local lidarSensor = WPILib.LidarLiteI2C()
local average = 0
local readLidar = function()
  average = average + .1* (lidarSensor:Get() -average)
  return average
  end

core.setCompositeRobot()

Robot.scheduler = Scheduler()
Robot.schedulerAuto = Scheduler()

checkWPILib("schedulers")

Robot.Teleop.Put("Drive",{
    Initialize = function()
      print"TeleopInit"
      toggleTime = WPILib.Timer.GetFPGATimestamp()
    end,
    Execute = function()
      if(OI.driveSpeed:Get() or OI.driveSpeed:Get() or OI.driveSlowSpeed:Get()) and (WPILib.Timer.GetFPGATimestamp() - toggleTime  >=.5) then
          toggleSlow = not toggleSlow
          toggleTime = WPILib.Timer.GetFPGATimestamp()
        end
      if toggleSlow then
        Robot.drive:MecanumDrive_Cartesian(OI.DriveX:Get()/2, OI.DriveY:Get()/2, OI.DriveTheta:Get()/2)
        else
     Robot.drive:MecanumDrive_Cartesian(OI.DriveX:Get(), OI.DriveY:Get(), OI.DriveTheta:Get())
      end
      --Robot.drive:TankDrive(Robot.joy:GetRawAxis(1), Robot.joy:GetRawAxis(3))
      if count % 1 == 0 then

        publish("Robot/Lidar", readLidar())
       -- print("Limit switch ",robotMap.lifterUpDown:IsRevLimitSwitchClosed())
      print(lidarSensor:Get())
        --print("BLTalon voltage: "..tostring(robotMap.BLTalon:GetOutputVoltage()).." current: "..tostring(robotMap.BLTalon:GetOutputCurrent()))
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
Robot.Autonomous.Put("Autonomous", require"PulsarStable.Auto.AutonomousStartup")
checkWPILib"Put Schedulers"


require"PulsarStable.pulsarIntake"
require"PulsarStable.lifter"

checkWPILib"end"
print("WPILib", WPILib)
print("WPILib.Timer", WPILib.Timer)
print("WPILib.Timer.GetFPGATimestamp", WPILib.Timer.GetFPGATimestamp)