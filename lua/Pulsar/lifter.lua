--Intake Pulsar

--debugPrint("intake started")
local core = require"core"
local lifterPower = 1
local lifterInOutPower = .4
local currentHeight = 0
local pid = require"PID"
local lifterPoint = require"Pulsar.lifterPoint"
local triggers = require"triggers"
-- the lifter lock off means that the arms cannot be moved
robotMap.lifterInOut:SetStatusFrameRateMs(2,20)
--robotMap.lifterInOut:GetEncPosition()
-- Intake In Command

  


local holdLifter = {
  Initialize = function()
  end,
  Execute = function()
    if(math.abs(currentHeight - (robotMap.lifterInOut:GetEncPosition()/1000 /25.4 * 120) )) >= 1 then
      Robot.Scheduler:StartCommand(lifterPoint(currentHeight))
    end
  end,
  IsFinished = function() 
    return not OI.lifterOut:Get()  
  end,
  End = function(self)
    robotMap.lifterInOut:Set(0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "LifterUpDown"
  },
}
local lifterOut = {
  Initialize = function()
    robotMap.lifterInOut:Set(-lifterInOutPower)
  end,
  Execute = function()
  end,
  IsFinished = function() 
    return not OI.lifterOut:Get()  
  end,
  End = function(self)
    robotMap.lifterInOut:Set(0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "LifterInOut"
  },
}

local lifterIn = {
  Initialize = function()
    -- motor code goes here
    robotMap.lifterInOut:Set(lifterInOutPower)
  end,
  Execute = function()
  end,
  IsFinished = function() 
    return (not OI.lifterIn:Get())
  end,
  End = function(self)
    robotMap.lifterInOut:Set(0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "LifterInOut"
  },
}

local lifterUp = {
  Initialize = function()
    -- motor code goes here
    print("lifterUP")
    robotMap.lifterUpDown:Set(OI.lifterUp:Get())
    robotMap.lifterUpDownTwo:Set(OI.lifterUp:Get())
  end,
  Execute = function()
  currentHeight = robotMap.lifterInOut:GetEncPosition()/1000 /25.4 * 120
  end,
  IsFinished = function() 
    return OI.lifterUp:Get() <=.2 or robotMap.lifterInOut:GetEncPosition()/1000 /25.4 * 120 >= 41  
  end,
  End = function(self)
    robotMap.lifterUpDown:Set(0)
    robotMap.lifterUpDownTwo:Set(0)
     --Robot.CurrentScheduler:StartCommand(holdLifter)
  end,
  Interrupted = function(self)
    print"lifterUp has been interrupted"
    self:End()
  end,
  subsystems = {
    "LifterUpDown"
  },
}

local lifterDown = {
  Initialize = function()
        print("lifterDown")
    robotMap.lifterUpDown:Set(-OI.lifterDown:Get())
    robotMap.lifterUpDownTwo:Set(-OI.lifterDown:Get())
  end,
  Execute = function()
  currentHeight = robotMap.lifterInOut:GetEncPosition()/1000 /25.4 * 120
  end,
  IsFinished = function()
    return OI.lifterDown:Get()<=.2 or (robotMap.lifterInOut:GetEncPosition()/1000 /25.4 * 120 )<=1 
  end,
  End = function(self)

    robotMap.lifterUpDown:Set(0)
    robotMap.lifterUpDownTwo:Set(0)
     --    Robot.CurrentScheduler:StartCommand(holdLifter)
  end,
  Interrupted = function(self)
    print"lifterDown has been Interrupted"
    self:End()
  end,
  subsystems = {
    "LifterUpDown"
  },
}


local lifterUpTrigger = function()
  -- debugPrint("intake in trigger ")
  if OI.lifterUp:Get()>=.2 then
    Robot.CurrentScheduler:StartCommand(lifterUp)
  end
end
local lifterDownTrigger = function()
  -- debugPrint("intake in trigger ")
  if OI.lifterDown:Get()>=.2 then
    Robot.CurrentScheduler:StartCommand(lifterDown)
  end
end
--[[
local lifterInTrigger = function()
  -- debugPrint("intake in trigger ")
  if OI.lifterIn:Get() then
    Robot.CurrentScheduler:StartCommand(lifterIn)
  end
end
local lifterOutTrigger = function()
  -- debugPrint("intake in trigger ")
  if OI.lifterOut:Get() then
    Robot.CurrentScheduler:StartCommand(lifterOut)
  end
end
local presetOneTrigger = function()
  -- debugPrint("intake in trigger ")
  if OI.preset:Get() then
    Robot.CurrentScheduler:StartCommand(presetOne)
  end
end

Robot.scheduler:AddTrigger(lifterUpTrigger)
Robot.scheduler:AddTrigger(lifterDownTrigger)
Robot.scheduler:AddTrigger(lifterInTrigger)
Robot.scheduler:AddTrigger(lifterOutTrigger)
Robot.scheduler:AddTrigger(presetOneTrigger)
--]]


local presetOne = lifterPoint(0)
local presetTwo = lifterPoint(14)
local presetThree = lifterPoint(28)
local presetFour = lifterPoint(41)
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.preset,presetOne))
--Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterUp,lifterUp))
--Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterDown,lifterDown))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterIn,lifterIn))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterOut,lifterOut))
Robot.scheduler:AddTrigger(lifterUpTrigger)
Robot.scheduler:AddTrigger(lifterDownTrigger)
--Robot.scheduler:AddTrigger(triggers.whenPressed(OI.presetTwo,cancel))
debugPrint("Lifter Finished")

