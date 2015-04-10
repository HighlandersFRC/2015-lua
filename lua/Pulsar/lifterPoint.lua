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
  local PID = pidLoop(.001,0,0)
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
      

      currentHeight = robotMap.lifterUpDown:GetPosition()
      response = -PID:Update(currentHeight)
      local current = robotMap.lifterUpDown:GetOutputCurrent()*(robotMap.lifterUpDown:GetBusVoltage() /robotMap.lifterUpDown:GetOutputVoltage())
      -- this expression is used to avoid cases where current spikes = inf
      if math.abs(robotMap.lifterUpDown:GetOutputVoltage()) == 0 then
        current = -100
        end
      RobotConfig.lifterClampDown = math.min(-.05,(robotMap.lifterUpDown:GetOutputVoltage() - (current/RobotConfig.lifterKi) + (RobotConfig.lifterDownCurrentLimit/RobotConfig.lifterKi)) / robotMap.lifterUpDown:GetBusVoltage())
     print("VClamp = ".. robotMap.lifterUpDown:GetOutputVoltage().." - ".. current .. " / "..RobotConfig.lifterKi.. " + ".. RobotConfig.lifterDownCurrentLimit.." / ".. RobotConfig.lifterKi.. " / " .. robotMap.lifterUpDown:GetBusVoltage())
      --print("Clamp",RobotConfig.lifterClampDown, "clamp comparison =", (robotMap.lifterUpDown:GetOutputVoltage() - (current/Ki) + (limitCurrentDown/Ki)) / robotMap.lifterUpDown:GetBusVoltage())
      robotMap.lifterUpDown:Set(clamp(response))
      
   -- print("moving lifter at", clamp(response), "Current ",robotMap.lifterUpDown:GetOutputCurrent()*(robotMap.lifterUpDown:GetBusVoltage() /       robotMap.lifterUpDown:GetOutputVoltage()))
    
     
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