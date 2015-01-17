--Intake Pulsar

--debugPrint("intake started")
local core = require"core"
local intakePower = .75


-- Intake In Command

local intakeLeftInCommand = {
  Initialize = function()
    -- motor code goes here
    robotMap.leftIntake:Set(intakePower)
  end,
  IsFinished = function() 
    return not OI.intakeLeftInBtn:Get()  
  end,
  End = function(self)
    robotMap.leftIntake:Set(0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "Leftintake"
  },
}

local intakeLeftOutCommand = {
  Initialize = function()
    -- motor code goes here
    robotMap.leftIntake:Set(-intakePower)
  end,
  IsFinished = function() 
    return not OI.intakeLeftOutBtn:Get()  
  end,
  End = function(self)
    robotMap.leftIntake:Set(0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "Leftintake"
  },
}
local intakeRightInCommand = {
  Initialize = function()
    -- motor code goes here
    robotMap.rightIntake:Set(-intakePower)
  end,
  IsFinished = function() 
    return not OI.intakeRightInBtn:Get()  
  end,
  End = function(self)
    robotMap.rightIntake:Set(0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "Rightintake"
  },
}

local intakeRightOutCommand = {
  Initialize = function()
    -- motor code goes here
    robotMap.rightIntake:Set(intakePower)
  end,
  IsFinished = function() 
    return not OI.intakeRightOutBtn:Get()  
  end,
  End = function(self)
    robotMap.rightIntake:Set(0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "Rightintake"
  },
}
-- triggers
local intakeLeftOut = function()
  -- debugPrint("intake in trigger ")
  if OI.intakeLeftOutBtn:Get() then
    Robot.CurrentScheduler:StartCommand(intakeLeftOutCommand)
  end
end
local intakeLeftIn = function()
  -- debugPrint("intake in trigger ")
  if OI.intakeLeftInBtn:Get() then
    Robot.CurrentScheduler:StartCommand(intakeLeftInCommand)
  end
end
local intakeRightOut = function()
  -- debugPrint("intake in trigger ")
  if OI.intakeRightOutBtn:Get() then
    Robot.CurrentScheduler:StartCommand(intakeRightOutCommand)
  end
end
local intakeRightIn = function()
  -- debugPrint("intake in trigger ")
  if OI.intakeRightInBtn:Get() then
    Robot.CurrentScheduler:StartCommand(intakeRightInCommand)
  end
end

Robot.scheduler:AddTrigger(intakeLeftIn)
Robot.scheduler:AddTrigger(intakeLeftOut)
Robot.scheduler:AddTrigger(intakeRightIn)
Robot.scheduler:AddTrigger(intakeRightOut)
--Robot.scheduler:SetDefaultCommand("intakeWheels",intakeWheelsStopCommand)
--Robot.Teleop.Put("intakeWheels", intakeWheelsStopCommand)
debugPrint("intake finished")

