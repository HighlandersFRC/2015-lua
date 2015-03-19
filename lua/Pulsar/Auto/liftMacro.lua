local liftMacro = function(liftHeight)
  print("lifter point created")
  -- this input is in inches
-- 120 mm per revolution 25.4 mm in an inch
  local core = require"core"
  local pidLoop = require"core.PID"
  local height = -liftHeight * 25.4 /120 * 1000

  local PID = pidLoop(.0015,0.006,0.005)

  local startTime = 0
  local lastTime = 0
  local currentHeight
  local response
  local toHeight = {
    Initialize = function()
      print("lifter going to ", height)
      robotMap.lifterUpDown:SetStatusFrameRateMs(2,20)
      startTime = WPILib.Timer.GetFPGATimestamp()
      PID.setpoint = height
    end,
    Execute = function()
     
      
      currentHeight = robotMap.lifterUpDown:GetEncPosition()
      response = -PID:Update(currentHeight)
      print("setting lifter values")
      robotMap.lifterUpDown:Set(response)
      --robotMap.lifterUpDownTwo:Set(response)
      print("Current Height: ", currentHeight,"   Target Height :", height, " Response : ", response)
    end,
    IsFinished = function() 
     return math.abs(height - currentHeight) <= 100
    end,
    End = function(self)
      robotMap.lifterUpDown:Set(0)
      --robotMap.lifterUpDownTwo:Set(0)
    end,
    Interrupted = function(self)
      print("lifterPoint has been interrrupted")
      self:End()
    end,
    IsInterruptible = function()
      return true
    end,
    subsystems = {
      "LifterUpDown"
    }
  }
  return toHeight
end
return liftMacro