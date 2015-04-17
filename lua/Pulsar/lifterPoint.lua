local clamp = function(inputValue)
  if inputValue >=RobotConfig.lifterClamp then
    return RobotConfig.lifterClamp
  elseif inputValue <= RobotConfig.lifterClampDown then
    return RobotConfig.lifterClampDown
  else
    return inputValue
  end
end
local liftMacro = function(liftHeight)
  print("lifter point created")
  -- this input is in inches
-- 120 mm per revolution 25.4 mm in an inch
  local core = require"core"
  local pidLoop = require"core.PID"
  local height = 0
  if liftHeight >= RobotConfig.lifterMax then
    height = -RobotConfig.lifterMax* 25.4 /120 * 1000
  elseif liftHeight <= RobotConfig.lifterMin then
    height = -RobotConfig.lifterMin * 25.4 /120 * 1000
  else 
    height = -liftHeight* 25.4 /120 * 1000
  end
  local PID = pidLoop(.001,0,.001)
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
      if not OI.lifterUpDownDisable:Get() then
        
        
      
      

      currentHeight = robotMap.lifterUpDown:GetPosition()
      response = -PID:Update(currentHeight)
    
      robotMap.lifterUpDown:Set(clamp(response))
    
     end
    end,
    IsFinished = function() 
      return false --math.abs(height - currentHeight) <=1000
    end,
    End = function(self)
      robotMap.lifterUpDown:Set(0)
     -- robotMap.lifterUpDownTwo:Set(0)
    end,
    Interrupted = function(self)
     -- print("lifterPoint has been interrrupted")
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