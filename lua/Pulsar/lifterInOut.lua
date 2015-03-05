local clamp = function(inputValue)
  if inputValue >= RobotConfig.lifterInOutClampIn then
    return RobotConfig.lifterInOutClampIn
  elseif inputValue <= -RobotConfig.lifterInOutClampOut then
    return -RobotConfig.lifterInOutClampOut
  else
    return inputValue
  end
end
local inOutMacro = function(targetPosition)
  print("lifter point created")
  -- this input is in inches
-- 120 mm per revolution 25.4 mm in an inch
  local core = require"core"
  local pidLoop = require"core.PID"

  local target = 0 
  if targetPosition >= RobotConfig.lifterInOutMax then
    
    target = RobotConfig.lifterInOutMax * 25.4 /120 * 756
    print("Above Max",target)
  elseif targetPosition <= RobotConfig.lifterInOutMin then
    
      target = RobotConfig.lifterInOutMin* 25.4 /120 * 756
      print("Below MIN",target)
  else 
    print("It was fine")
    target = targetPosition * 25.4 /120 * 756
  end

local PID = pidLoop(.004,0,0)
local startTime = 0
local lastTime = 0
local currentPosition
local response
local toPosition = {
  Initialize = function()
    print("lifterInOut going to ", target)
    robotMap.lifterInOut:SetStatusFrameRateMs(2,20)
    startTime = WPILib.Timer.GetFPGATimestamp()
    PID.setpoint = target
  end,
  Execute = function()
    currentPosition = robotMap.lifterInOut:GetEncPosition()
    response = -PID:Update(currentPosition)
    robotMap.lifterInOut:Set(clamp(response))
    print("Current Height: ", currentPosition,"   Target Height :", target, " Response : ",clamp(response))
  end,
  IsFinished = function() 
    return false --math.abs(height - currentHeight) <=1000
  end,
  End = function(self)
    robotMap.lifterInOut:Set(0)
  end,
  Interrupted = function(self)
    print("lifterPoint has been interrrupted")
    self:End()
  end,
  IsInterruptible = function()
    return true
  end,
  subsystems = {
    "LifterInOut"
  }
}
return toPosition
end
return inOutMacro