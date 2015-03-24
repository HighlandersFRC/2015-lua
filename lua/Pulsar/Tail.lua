local core = require"core"
local tailPower = 0.6
local triggers = require"triggers"
local tailPosition = require"Pulsar.TailPosition"
local lifterPoint = require"Pulsar.lifterPoint"
local tailProngPower = .5
local current = 0
local motorStallRatio = 3.33
local tailCount = 0 
local parallel = require"command.Parallel"
local function degrees2ticks(degrees)
  return degrees /360*1440
end

local function ticks2Degrees(ticks)
  return ticks /1440*360
end
local tailProngsUp = {
  Initialize = function()
    robotMap.tailProngs:Set(tailProngPower)
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

      --print("adjustedVal:",motor:GetOutputCurrent()*1/power,"raw value:",motor:GetOutputCurrent())
      -- use this calculation to calculate current at .5 power it is about 30 amps
      --print(math.abs(current / motor:GetOutputVoltage() /motorStallRatio)  )
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
local tailProngsDown = {
  Initialize = function()
    robotMap.tailProngs:Set(-tailProngPower)
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

      --print("adjustedVal:",motor:GetOutputCurrent()*1/power,"raw value:",motor:GetOutputCurrent())
      -- use this calculation to calculate current at .5 power it is about 30 amps
      --print(math.abs(current / motor:GetOutputVoltage() /motorStallRatio)  )
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
    if (ticks2Degrees(-robotMap.tail:GetPosition()) <= RobotConfig.tailMax) then
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
    if (ticks2Degrees(-robotMap.tail:GetPosition()) >= RobotConfig.tailMin) then
      local pwr = -math.min(tailPower, math.abs((RobotConfig.tailMin - ticks2Degrees(robotMap.tail:GetPosition()) ) / 10))
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
local tailDownPreset = parallel(tailPosition(-66.5),lifterPoint(11))



local tailPresetOne = tailPosition(45)
local tailPresetTwo = tailPosition(80) -- should be 80

Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailPresetOne,tailDownPreset))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailPresetTwo,tailPresetTwo))
Robot.scheduler:AddTrigger(triggers.whenPressed({Get = function() return OI.tail:GetPOV() == 90 end},tailUp))
Robot.scheduler:AddTrigger(triggers.whenPressed({Get = function() return OI.tail:GetPOV() == 270 end},tailDown))
Robot.scheduler:AddTrigger(triggers.whenPressed({Get = function() return OI.tail:GetPOV()== 180 end},tailProngsDown))
Robot.scheduler:AddTrigger(triggers.whenPressed({Get = function() return OI.tail:GetPOV()== 0 end},tailProngsUp))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailPresetOne,tailDown))
--Robot.scheduler:AddTrigger(tailTrigger)
Robot.scheduler:StartCommand(tailMove)
checkWPILib"after debugPrint"