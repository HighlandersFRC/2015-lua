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
require"Pulsar.OI"
require"Pulsar.RobotMap"
require"Pulsar.RobotConfig"
require"Pulsar.VoltagePublish"
require "ArduLidar"
local Scheduler = require"command.Scheduler"
print"requires finished"
local toggleSlow = false
local toggleTime = WPILib.Timer.GetFPGATimestamp()
print("before zeroing", robotMap.navX:GetYaw())
robotMap.navX:ZeroYaw()
print("after zeroing", robotMap.navX:GetYaw())
--robotMap.navX:SetYawPitchRoll(0,0,0,0)
--local lidarSensor = WPILib.LidarLiteI2C()
--require("mqtt_lua_console").start()
checkWPILib("requires")
--local lidarSensor = WPILib.LidarLiteI2C()
local average = 0
local readLidar = function()
  --average = average + .1* (lidarSensor:Get() -average)
  return average
end

core.setCompositeRobot()

Robot.scheduler = Scheduler()
Robot.schedulerAuto = Scheduler()

checkWPILib("schedulers")
autonomousVersion="Pulsar.Auto.NoAuto"
Robot.Disabled.Put("autoChooser",require"Pulsar.Auto.autoChooser")
Robot.Teleop.Put("Drive",{
    Initialize = function()
      print"TeleopInit"
      toggleTime = WPILib.Timer.GetFPGATimestamp()
    end,
    Execute = function()
      --print("limitSwitch",robotMap.lifterUpDown:IsRevLimitSwitchClosed())
      if(OI.driveSpeed:Get() or OI.driveSpeed:Get() or OI.driveSlowSpeed:Get()) and (WPILib.Timer.GetFPGATimestamp() - toggleTime  >=.5) then
        toggleSlow = not toggleSlow
        toggleTime = WPILib.Timer.GetFPGATimestamp()
      end
      if toggleSlow then
        Robot.drive:MecanumDrive_Cartesian(OI.DriveX:Get()/2, OI.DriveY:Get()/2, OI.DriveTheta:Get()/2)
      else
        Robot.drive:MecanumDrive_Cartesian(OI.DriveX:Get(), OI.DriveY:Get()/2, OI.DriveTheta:Get())
      end
      --Robot.drive:TankDrive(Robot.joy:GetRawAxis(1), Robot.joy:GetRawAxis(3))
      if count % 50 == 0 then

        print("height",robotMap.lifterInOut:GetPosition())
        -- print("Limit switch ",robotMap.lifterUpDown:IsRevLimitSwitchClosed())
        --print(lidarSensor:Get())
        --print("BLTalon voltage: "..tostring(robotMap.BLTalon:GetOutputVoltage()).." current: "..tostring(robotMap.BLTalon:GetOutputCurrent()))
        -- print("Current Height", robotMap.lifterUpDown:GetEncPosition())
        --error("trying to fill an already full mind")
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



Robot.Disabled.Put("DisabledCoast", {
    Initialize = function()
      robotMap.BRTalon:ConfigNeutralMode(2)
      robotMap.BLTalon:ConfigNeutralMode(2) 
      robotMap.FRTalon:ConfigNeutralMode(2) 
      robotMap.FLTalon:ConfigNeutralMode(2)
      end
    })


Robot.Teleop.Put("Scheduler",Robot.scheduler)
Robot.Teleop.Put("SetMotors", {
    Initialize = function()
      robotMap.BRTalon:ConfigNeutralMode(2) 
      robotMap.BLTalon:ConfigNeutralMode(2) 
      robotMap.FRTalon:ConfigNeutralMode(2) 
      robotMap.FLTalon:ConfigNeutralMode(2)
      robotMap.FLTalon:SetControlMode(0)
      robotMap.BLTalon:SetControlMode(0)
      robotMap.FRTalon:SetControlMode(0)
      robotMap.BRTalon:SetControlMode(0)
      robotMap.lifterUpDown:SetControlMode(0)
      robotMap.lifterUpDownTwo:SetControlMode(WPILib.CANTalon.kFollower)
      robotMap.lifterUpDownTwo:Set(7)
      robotMap.BRTalon:SetControlMode(0)
      
      robotMap.BLTalon:Set(0)
      robotMap.BRTalon:Set(0)
      robotMap.FLTalon:Set(0)
      robotMap.FRTalon:Set(0)
      
      robotMap.lifterUpDown:Set(0)
      robotMap.lifterInOut:Set(0)
      robotMap.tail:Set(0)
      
    end
  })
Robot.Autonomous.Put("Autonomous", require"Pulsar.Auto.AutonomousStartup")
checkWPILib"Put Schedulers"

require"Pulsar.Tail"
require"Pulsar.pulsarIntake"
require"Pulsar.lifter"
--require"Pulsar.Tail"
require"Pulsar.limitProtection"
checkWPILib"end"
print("WPILib", WPILib)
print("WPILib.Timer", WPILib.Timer)
print("WPILib.Timer.GetFPGATimestamp", WPILib.Timer.GetFPGATimestamp)