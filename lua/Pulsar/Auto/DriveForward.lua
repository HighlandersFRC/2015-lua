
print("drive forward auto started")
local driveForward = function(pwr, time)
  local gyro = require"Gyro"
  local core = require"core"
  local power = pwr
  local delay = time
  local startTime = 0
  local lastTime = 0
  local heading = 0
-----------------------------
  local pidLoop = require"core.PID"
  local PID = pidLoop(0.16,.002,-1)
-----------------------------
  local count = 0
  local goForward = {
    Initialize = function()
      print("initializing")
     PID = pidLoop(0.16,.002,-1)
      startTime = 0
      count = 0
      heading = 0
      lastTime = WPILib.Timer.GetFPGATimestamp()
      gyro.Calibrate(100,.01)
      startTime = WPILib.Timer.GetFPGATimestamp()
    --  Robot.drive:MecanumDrive_Cartesian(0, 0, -power)
    end,
    Execute = function()
      local x,y,z = gyro.Get()
      local deltaTime = WPILib.Timer.GetFPGATimestamp() - lastTime
      local X = x * (deltaTime) 
      heading = heading + X
      lastTime = WPILib.Timer.GetFPGATimestamp()
      local response = PID:Update(heading)
      if count % 50 == 0 then
        print(x .."    " .."       "..y.."        "..z)
        print("Heading == " .. heading )
        print("response   " .. response)
      end
      count = count + 1
      -- update talon speeds gyro One
      Robot.drive:MecanumDrive_Cartesian(0, response, -power)
    end,
    IsFinished = function() 
      return false--(startTime + delay <= WPILib.Timer.GetFPGATimestamp()) 
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

