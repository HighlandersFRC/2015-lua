local core = require"core"
local tailPower = 0.6
local triggers = require"triggers"
local tailPosition = require"Pulsar.TailPosition"
local lifterPoint = require"Pulsar.lifterPoint"
local function degrees2ticks(degrees)
  return degrees /360*1440
end

local function ticks2Degrees(ticks)
  return ticks /1440*360
end
local tailMove = {
  Initialize = function()
    robotMap.tail:SetVoltageRampRate(10)
    print("Started moving")
  end,
  Execute = function()
    --print(robotMap.tail:GetPosition())
    if(OI.tail:GetPOV()==0) then
      if (ticks2Degrees(-robotMap.tail:GetPosition()) <= RobotConfig.tailMax) then
        local pwr = math.min(tailPower, math.abs((RobotConfig.tailMax - ticks2Degrees(robotMap.tail:GetPosition()) ) / 10))
        robotMap.tail:Set(-pwr)
      else
        robotMap.tail:SetVoltageRampRate(0)
        robotMap.tail:Set(0)
      end
    elseif OI.tail:GetPOV()==180 then
      if (ticks2Degrees(-robotMap.tail:GetPosition()) >= RobotConfig.tailMin) then
        local pwr = -math.min(tailPower, math.abs((RobotConfig.tailMin - ticks2Degrees(robotMap.tail:GetPosition()) ) / 10))
        robotMap.tail:Set(pwr)
      else
        robotMap.tail:SetVoltageRampRate(0)
        robotMap.tail:Set(0)
      end
    else
      robotMap.tail:SetVoltageRampRate(0)
      robotMap.tail:Set(0)
    end
  end,
  IsFinished = function() 
    return false
  end,
  End = function(self)
    print("Ending")
    robotMap.tail:Set(0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "Tail"
  },
}
local tailDown = {
  Initialize = function()

    Robot.scheduler:StartCommand(tailPosition(-66.5))
    Robot.scheduler:StartCommand(lifterPoint(11))
  end,
  Execute = function()
    --print(ticks2Degrees(robotMap.tail:GetPosition()))
  end,
  IsFinished = function() 
    return false
  end,
  End = function(self)
   -- print("Ending")
    robotMap.tail:Set(0)
    robotMap.lifterUpDown:Set(0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
  },
}

local tailPresetOne = tailPosition(45)
local tailPresetTwo = tailPosition(80) -- should be 80

Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailPresetOne,tailDown))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailPresetTwo,tailPresetTwo))
Robot.scheduler:AddTrigger(triggers.whenPressed({Get = function() return OI.tail:GetPOV()> -1 end},tailMove))

--Robot.scheduler:AddTrigger(tailTrigger)
Robot.scheduler:StartCommand(tailMove)
checkWPILib"after debugPrint"