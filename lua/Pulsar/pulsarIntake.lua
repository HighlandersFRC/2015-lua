--Intake Pulsar

--debugPrint("intake started")
local core = require"core"
local intakePower = .6
local triggers = require"triggers"

-- Intake In Command

local intakeLeftOutCommand = {
  Initialize = function()
    -- motor code goes here
    robotMap.leftIntake:Set(OI.intakeLeftOut:Get())
  end,
  IsFinished = function() 
    return OI.intakeLeftOut:Get() <.2 
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

local intakeLeftInCommand = {
  Initialize = function()
    -- motor code goes here
    robotMap.leftIntake:Set(-intakePower)
  end,
  IsFinished = function() 
    return not OI.intakeLeftIn:Get() 
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
local intakeRightOutCommand = {
  Initialize = function()
    -- motor code goes here
    robotMap.rightIntake:Set(-OI.intakeRightOut:Get())
  end,
  IsFinished = function() 
    return OI.intakeRightOut:Get() <.2  
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

local intakeRightInCommand = {
  Initialize = function()
    print("Right Button")
    -- motor code goes here
    robotMap.rightIntake:Set(intakePower)
  end,
  IsFinished = function() 
    return not OI.intakeRightIn:Get()  
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
  if OI.intakeLeftOut:Get()>=.2 then
    Robot.CurrentScheduler:StartCommand(intakeLeftOutCommand)
  end
end
local intakeRightOut = function()
  -- debugPrint("intake in trigger ")
  if OI.intakeRightOut:Get()>=.2 then
    Robot.CurrentScheduler:StartCommand(intakeRightOutCommand)
  end
end
checkWPILib"before intake triggers"
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.intakeLeftIn,intakeLeftInCommand))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.intakeRightIn,intakeRightInCommand))
Robot.scheduler:AddTrigger(intakeLeftOut)
Robot.scheduler:AddTrigger(intakeRightOut)

checkWPILib"after intake triggers"
--Robot.scheduler:SetDefaultCommand("intakeWheels",intakeWheelsStopCommand)
--Robot.Teleop.Put("intakeWheels", intakeWheelsStopCommand)
debugPrint("intake finished")

checkWPILib"after debugPrint"