local clamp = function(inputValue)
  if inputValue >=RobotConfig.tailClamp then
    return RobotConfig.tailClamp 
  elseif inputValue <= -RobotConfig.tailClamp then
    return -RobotConfig.tailClamp
  else
    return inputValue
  end
end
local function degrees2ticks(degrees)
  return degrees /360*1440
end
local function ticks2Degrees(ticks)
  return ticks *360/1440
end
local liftMacro = function(target)
  --print("tail point created")
  local core = require"core"
  local pidLoop = require"core.PID"
  local angle = 0
  if target >= RobotConfig.tailMax then
    --print("adjusting 1")
    angle = degrees2ticks(RobotConfig.tailMax) 
  elseif target <= RobotConfig.tailMin then
     --print("adjusting 2")
    angle = degrees2ticks(RobotConfig.tailMin)
  else 
     --print("not adjusted")
   angle = degrees2ticks(target)
  end

  local PID = pidLoop(.004,0,.005)
  local startTime = 0
  local lastTime = 0
  local currentAngle
  local response
  local toAngle = {
    Initialize = function()
     -- robotMap.tail:SetVoltageRampRate(10)
      print("tail going to ", angle)
      robotMap.tail:SetStatusFrameRateMs(2,20)
      robotMap.tail:SetVoltageRampRate(0)
      startTime = WPILib.Timer.GetFPGATimestamp()
      PID.setpoint = angle
      PID.maxOutput = RobotConfig.tailClamp
      PID.minOutput = -RobotConfig.tailClamp*.7
      --PID.Continuous = true;
    end,
    Execute = function()
      currentAngle = robotMap.tail:GetPosition()
     
      response = PID:Update(currentAngle)
      --print("Tail target ", angle, "current angle", currentAngle,"response", response, "clamped response", clamp(response))
      robotMap.tail:Set(response+.25 * math.cos(ticks2Degrees(currentAngle)*math.pi/180))
    end,
    IsFinished = function() 
      return false 
    end,
    End = function(self)
      robotMap.tail:Set(0)
    end,
    Interrupted = function(self)
      print("tail has been interrrupted")
      self:End()
    end,
    IsInterruptible = function()
      return true
    end,
    subsystems = {
      "Tail"
    }
  }
  return toAngle
end
return liftMacro