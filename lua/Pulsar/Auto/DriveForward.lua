
print("drive forward auto started")
local driveForward = function(pwr, time)
  local gyro = require"Gyro"
  local core = require"core"
  local power = pwr
  local delay = time
  local startTime = 0
  local lastTime = 0
  local heading = 0
  local startHeading = 0
-----------------------------
  local pidLoop = require"core.PID"
  local PID = pidLoop(0.16,.000,0)
-----------------------------
  local count = 0
  local goForward = {
    Initialize = function()
      print("initializing")
     PID = pidLoop(0.16,.002,0)
      startTime = 0
      count = 0
      heading = 0
     lastTime = WPILib.Timer.GetFPGATimestamp()
      startTime = WPILib.Timer.GetFPGATimestamp()
      startHeading = robotMap.navX:GetYaw()
    end,
    Execute = function() 
      heading = robotMap.navX:GetYaw()-startHeading
      lastTime = WPILib.Timer.GetFPGATimestamp()
      local response = PID:Update(heading)
      if count % 50 == 0 then
        print("Heading == " .. heading )
        print("response   " .. response)
      end
      count = count + 1
      -- update talon speeds gyro One
      Robot.drive:MecanumDrive_Cartesian(0,heading , -power)
    end,
    IsFinished = function() 
      return (startTime + delay <= WPILib.Timer.GetFPGATimestamp()) 
    end,
    End = function(self)
      Robot.drive:MecanumDrive_Cartesian(0, 0,0)
    end,
    Interrupted = function(self)
      self:End()
    end,
    subsystems = {
      "DriveTrain"
    }
  }
  return goForward
end
--Robot.scheduler:SetDefaultCommand("intakeWheels",intakeWheelsStopCommand)
--Robot.Teleop.Put("intakeWheels", intakeWheelsStopCommand)
--debugPrint("running go forward autonomous")


return driveForward
