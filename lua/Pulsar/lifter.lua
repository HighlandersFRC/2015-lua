--Intake Pulsar

--debugPrint("intake started")
local core = require"core"
local lifterPower = .5
local lifterInOutPower = .5
-- the lifter lock off means that the arms cannot be moved

-- Intake In Command


local lifterOut = {
  Initialize = function()
    -- motor code goes here
    
    robotMap.lifterInOut:Set(-lifterInOutPower)
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
    robotMap.lifterUpDown:Set(lifterInOutPower)
  end,
  IsFinished = function() 
    return not OI.lifterIn:Get()  
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
    robotMap.lifterLock:Set(true)
    robotMap.lifterUpDown:Set(-lifterPower)
  end,
  IsFinished = function() 
    return not OI.lifterUp:Get()  
  end,
  End = function(self)
    robotMap.lifterUpDown:Set(0)
    robotMap.lifterLock:Set(false)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "LifterUpDown"
  },
}

local lifterDown = {
  Initialize = function()
    -- motor code goes here
    robotMap.lifterLock:Set(true)
    robotMap.lifterUpDown:Set(lifterPower)
  end,
  IsFinished = function() 
    return not OI.lifterDown:Get()  
  end,
  End = function(self)
    
    robotMap.lifterUpDown:Set(0)
    robotMap.lifterLock:Set(false)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "LifterUpDown"
  },
}

-- triggers

Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterDown,lifterDown))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterUp,lifterUp))

--Robot.scheduler:SetDefaultCommand("intakeWheels",intakeWheelsStopCommand)
--Robot.Teleop.Put("intakeWheels", intakeWheelsStopCommand)
debugPrint("Lifter Finished")

