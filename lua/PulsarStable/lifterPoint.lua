local clamp = function(inputValue)
  if inputValue >=RobotConfig.lifterClamp then
    return RobotConfig.lifterClamp
  elseif inputValue <= -RobotConfig.lifterClamp then
    return -RobotConfig.lifterClamp
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
  elseif liftHeight <= 1 then
    height = -RobotConfig.lifterMin * 25.4 /120 * 1000
  else 
    height = -liftHeight* 25.4 /120 * 1000
  end

  local PID = pidLoop(.002,0,0)
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
      robotMap.lifterUpDown:Set(clamp(response))
      robotMap.lifterUpDownTwo:Set(clamp(response))
      --print("Current Height: ", currentHeight,"   Target Height :", height, " Response : ", response,"Current Position ")
    end,
    IsFinished = function() 
      return false --math.abs(height - currentHeight) <=1000
    end,
    End = function(self)
      robotMap.lifterUpDown:Set(0)
      robotMap.lifterUpDownTwo:Set(0)
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
