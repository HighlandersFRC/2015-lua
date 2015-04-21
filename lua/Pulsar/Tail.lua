local core = require"core"
local tailPower = 0.6
local triggers = require"triggers"
local tailPosition = require"Pulsar.TailPosition"
local lifterPoint = require"Pulsar.lifterPoint"
local tailProngPowerDown = .30
local tailProngPowerUp = .60
local current = 0
local motorStallRatio = 3.33
local tailCount = 0 
local parallel = require"command.Parallel"
local start = require"command.Start"
local Compare = require"dataflow.Compare"
local And = require"dataflow.And"
local Or = require"dataflow.Or"

local function degrees2ticks(degrees)
  return degrees /360*1440
end

local function ticks2Degrees(ticks)
  return ticks /1440*360
end

robotMap.tail:SetPosition(degrees2ticks(100))



local tailHold = {
  Initialize = function()
    local holdingHeight = ticks2Degrees(robotMap.tail:GetPosition())
    print("Holding angle :",holdingHeight)
    Robot.CurrentScheduler:StartCommand(tailPosition(holdingHeight))
  end,
  Execute = function()
  end,
  IsFinished = function() 
    return true
  end,
  End = function(self)
  end,
  Interrupted = function(self)
    print"Tail Hold has been interrupted"
    self:End()
  end,
  subsystems = {},
}


local tailProngsDown = {
  Initialize = function()
    robotMap.tailProngs:Set(-tailProngPowerDown)
    tailCount = 0
  end,
  Execute = function() 
    if robotMap.tailProngs:GetOutputVoltage() ~= 0 then
      current = math.abs(robotMap.tailProngs:GetOutputCurrent()*(robotMap.tailProngs:GetBusVoltage() / robotMap.tailProngs:GetOutputVoltage()))
      if math.abs(current / robotMap.tailProngs:GetOutputVoltage() /motorStallRatio) >0.5 then
        tailCount = tailCount + 1
      else 
        if tailCount >0 then
          tailCount = tailCount -1
        end
      end
      if tailCount >=5 then
        robotMap.tailProngs:Set(0)
      end
    end
  end,  
  End = function()

  end,
  subsystems = {
    "TailProngs"
  },
  Interrupted = function(self)
    self:End()
  end,
  IsFinished = function()
    return false
  end
}
local tailProngsUp = {
  Initialize = function()
    robotMap.tailProngs:Set(tailProngPowerUp)
    tailCount = 0
  end,
  Execute = function() 
    if robotMap.tailProngs:GetOutputVoltage() ~= 0 then
      current = math.abs(robotMap.tailProngs:GetOutputCurrent()*(robotMap.tailProngs:GetBusVoltage() / robotMap.tailProngs:GetOutputVoltage()))
      if math.abs(current / robotMap.tailProngs:GetOutputVoltage() /motorStallRatio) >0.5 then
        tailCount = tailCount + 1
      else 
        if tailCount >0 then
          tailCount = tailCount -1
        end
      end
      if tailCount >=5 then
        robotMap.tailProngs:Set(0)
      end
    end
  end,  
  End = function()

  end,
  subsystems = {
    "TailProngs"
  },
  Interrupted = function(self)
    self:End()
  end,
  IsFinished = function()
    return false
  end
}
local tailUp = {
  Initialize = function()
    robotMap.tail:SetVoltageRampRate(10)
  end,
  Execute = function()
    print("trying to run tail up "..tostring(ticks2Degrees(robotMap.tail:GetPosition())))
    if (ticks2Degrees(robotMap.tail:GetPosition()) <= RobotConfig.tailMax) then
      local pwr = math.min(tailPower, math.abs((RobotConfig.tailMax - ticks2Degrees(robotMap.tail:GetPosition()) ) / 10))
      robotMap.tail:Set(-pwr)
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
    robotMap.tail:SetVoltageRampRate(10)
    print("Started moving")
  end,
  Execute = function()
    print("trying to run tail down "..tostring(ticks2Degrees(robotMap.tail:GetPosition())))
    if (ticks2Degrees(robotMap.tail:GetPosition()) >= RobotConfig.tailMin) then
      local pwr = -math.min(-tailPower, math.abs((RobotConfig.tailMin - ticks2Degrees(robotMap.tail:GetPosition()) ) / 10))
      robotMap.tail:Set(pwr)
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
local tailDownPosition = {
  Initialize = function()
    Robot.scheduler:StartCommand(lifterPoint(11))
    Robot.scheduler:StartCommand(tailPosition(-66.5))

  end,
  Execute = function()
  end,
  IsFinished = function() 
    return true
  end,
  End = function(self)
  end,
  Interrupted = function(self)
    print"Tail down preset has been interrupted"
    self:End()
  end,
  subsystems = {},
}
local tailDownPreset = parallel(start(tailPosition(-66.5)),start(lifterPoint(10)), start(tailProngsUp))

local tailUpPreset = tailPosition(65) -- should be 80
print"tailDown"
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailDown,tailDownPreset))
print"tailHigh"
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailHigh,tailUpPreset))
print"tailStow"
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailStow, tailPosition(85)))
print"tailUpDown"
Robot.scheduler:AddTrigger(triggers.whenPressed(Compare(OI.tailUpDown, "<", -0.2),tailUp))
Robot.scheduler:AddTrigger(triggers.whenPressed(Compare(OI.tailUpDown, ">", 0.2),tailDown))
print"tailProngsDown"
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailProngsDown,tailProngsDown))
print"tailProngsUp"
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailProngsUp,tailProngsUp))
print"tail Or"
Robot.scheduler:AddTrigger(triggers.whenReleased(Or(Compare(OI.tailUpDown, ">", 0.2), Compare(OI.tailUpDown, "<", -0.2)),tailHold))
print"tail triggers set"

checkWPILib"after debugPrint"