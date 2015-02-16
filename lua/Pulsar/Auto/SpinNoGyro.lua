
print("SpinTurn Started")
local spinTurn = function(waitTime)
  local angle = rotation
  local count = 0
  local startTime = 0
  local time = math.abs(waitTime)
  local t = waitTime
  local turn = {
    Initialize = function()
     count = 0
      startTime = WPILib.Timer.GetFPGATimestamp()
    end,
    Execute = function()
        Robot.drive:MecanumDrive_Cartesian(0, waitTime/t, 0)
    end,
    IsFinished = function() 
      return WPILib.Timer.GetFPGATimestamp() -startTime >= time
    end,
    End = function(self)
      print("ENDING THE COMMAND HERE___________________")
      Robot.drive:MecanumDrive_Cartesian(0, 0,0)
    end,
    Interrupted = function(self)
      print("I have been interrrupted")
      self:End()
    end,
    subsystems = {
      "DriveTrain"
    }
  }
  return turn
end
return spinTurn
