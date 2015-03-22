local clamp = function(val, clampValNeg,clampValPos)
  if val >= clampValPos then
    val = clampValPos
  end
  if val <= clampValNeg then
    val = clampValNeg
  end
  return val
end

local driveForward = function(pwr, trig, time)
  local gyro = require"Gyro"
  local core = require"core"
  local pwrMultiple = 1
  local power = pwr * pwrMultiple
  local accel = 2
  local delay = time
  local startTime = 0
  local lastTime = 0
  local heading = 0
  local startHeading = 0
-----------------------------
  local pidLoop = require"core.PID"
  local PID = pidLoop(0.1,.001,.01)
  PID.minInput = -180
  PID.maxInput = 180
  PID.continuous = true
-----------------------------
  local count = 0
  local goForward = {
    Initialize = function()
      print("initializing triggered drive")
      startTime = 0
      count = 0
      heading = 0
      lastTime = WPILib.Timer.GetFPGATimestamp()
      startTime = WPILib.Timer.GetFPGATimestamp()
      startHeading = robotMap.navX:GetYaw()
      --PID.setPoint = startHeading
    end,
    Execute = function()
      heading = robotMap.navX:GetYaw() - startHeading
      lastTime = WPILib.Timer.GetFPGATimestamp()
      local response = PID:Update(heading)
      publish("Robot/Heading", heading..","..startHeading)
      count = count + 1
      -- update talon speeds gyro One
      Robot.drive:MecanumDrive_Cartesian(0,response , -clamp(power * 12/robotMap.PDP:GetVoltage(),(-WPILib.Timer.GetFPGATimestamp() + startTime)*pwrMultiple * accel , pwrMultiple * accel * (WPILib.Timer.GetFPGATimestamp() - startTime)))
    end,
    IsFinished = function()
      if trig:Get() then
        print"TriggeredDriver terminated by trigger"
        return true 
      end
      if delay and startTime + delay <= WPILib.Timer.GetFPGATimestamp() then
        print"TriggeredDrive terminated by timeout."
        return true
      end
      return false--(trig:Get() or (delay and startTime + delay <= WPILib.Timer.GetFPGATimestamp())) 
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

return driveForward