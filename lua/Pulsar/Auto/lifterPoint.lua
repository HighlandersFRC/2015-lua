
local liftMacro = function(liftHeight)
  -- this input is in inches
-- 120 mm per revolution 25.4 mm in an inch
  local core = require"core"
  local pidLoop = require"core.PID"
  local height = liftHeight * 25.4 /120 * 1000
  local PID = pidLoop(.05,0,0)
  local startTime = 0
  local lastTime = 0
  local currentHeight
  local response
  local toHeight = {
    Initialize = function()
      robotMap.lifterUpDown:SetStatusFrameRateMs(2,20)
      startTime = WPILib.Timer.GetFPGATimestamp()
      PID.setPoint = height
    end,
    Execute = function()
      currentHeight = robotMap.lifterUpDown:GetEncPosition()
      response = PID:Update(currentHeight)
      robotMap.lifterUpDown:Set(response)
    end,
    IsFinished = function() 
     return math.abs(height - currentHeight) <=1000
    end,
    End = function(self)
      robotMap.lifterUpDown:Set(0)
      --robotMap.lifterUpDownTwo:Set(0)
    end,
    Interrupted = function(self)
      print("I have been interrrupted")
      self:End()
    end,
    subsystems = {
      "lifterUpDown"
    }
  }
  return toHeight
end
return liftMacro
