
print("SpinTurn Started")
local spinTurn = function(rotation)
  
  local core = require"core"
  
-----------------------------
  local pidLoop = require"core.PID"
  local PID = pidLoop(0.165,0.05,0)
-----------------------------
  local angle = rotation
  local heading = 0
  local startTime = 0
  local lastTime = 0
  local turn = {
    Initialize = function()
      PID.minOutput = -.5
      PID.maxOutput = .5
      PID.minInput = -180
      PID.maxInput = 180
      PID.continuous = true
      
      
      print("SpinTurn turning")
      heading = 0
      PID.setpoint = angle
      print"starting timestamps"
      startTime =  WPILib.Timer.GetFPGATimestamp()
      lastTime = WPILib.Timer.GetFPGATimestamp()
      print"finished timestamps"
      print"finished calibration"
      --  Robot.drive:MecanumDrive_Cartesian(0, 0, -power)
    end,
    Execute = function()
       heading = robotMap.navX:GetYaw()
      print("Heading",heading)
      publish("Robot/Heading", heading)
      local response = PID:Update(heading)    
      Robot.drive:MecanumDrive_Cartesian(0, response, 0)
      lastTime = WPILib.Timer.GetFPGATimestamp()
    end,
    IsFinished = function() 
      
      return math.abs(heading- angle)<= 2
    end,
    End = function(self)
      
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
