
print("SpinTurn Started")
local spinTurn = function(rotation)

  local gyro = require"Gyro"
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
      print("SpinTurn turning")
      heading = 0
      PID.setpoint = angle
      startTime = WPILib.Timer.GetFPGATimestamp()
      lastTime = WPILib.Timer.GetFPGATimestamp()
      gyro.Calibrate(100,.01)
      --  Robot.drive:MecanumDrive_Cartesian(0, 0, -power)
    end,
    Execute = function()
      local x,y,z = gyro:Get()
      
      local deltaTime = WPILib.Timer.GetFPGATimestamp() - lastTime
      local X = x * (deltaTime) * 180/math.pi

      heading = heading + X
            print(heading)
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
