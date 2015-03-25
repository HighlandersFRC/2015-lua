local core = require"core"
local tailPower = 0.6
local triggers = require"triggers"
local tailPosition = require"Pulsar.TailPosition"
local lifterPoint = require"Pulsar.lifterPoint"
local tailProngPower = .40
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
      robotMap.tailProngs:Set(-tailProngPower)
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
      robotMap.tailProngs:Set(tailProngPower)
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
  local tailDownPreset = parallel(tailPosition(-66.5),lifterPoint(11))



  local tailPresetOne = tailPosition(60)
  local tailPresetTwo = tailPosition(70) -- should be 80

  Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailPresetOne,tailDownPosition))
  Robot.scheduler:AddTrigger(triggers.whenPressed(OI.tailPresetTwo,tailPresetTwo))
  Robot.scheduler:AddTrigger(triggers.whenPressed({Get = function() return OI.tail:GetPOV() == 90 end},tailUp))
  Robot.scheduler:AddTrigger(triggers.whenPressed({Get = function() return OI.tail:GetPOV() == 270 end},tailDown))
  Robot.scheduler:AddTrigger(triggers.whenPressed({Get = function() return OI.tail:GetPOV()== 180 end},tailProngsDown))
  Robot.scheduler:AddTrigger(triggers.whenPressed({Get = function() return OI.tail:GetPOV()== 0 end},tailProngsUp))
  
  Robot.scheduler:AddTrigger(triggers.whenReleased({Get = function() return OI.tail:GetPOV()> -1 end},tailHold))

  checkWPILib"after debugPrint"