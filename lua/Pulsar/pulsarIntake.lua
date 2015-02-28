--Intake Pulsar

--debugPrint("intake started")
local core = require"core"
local intakePower = .5
local triggers = require"triggers"

-- Intake In Command
local lidarSensor = WPILib.LidarLiteI2C()
local average = 0
local readLidar = function()
  average = average + .1* (lidarSensor:Get() -average)
  return average
  end
print(readLidar())
local intakeLeftOutCommand = {
  Initialize = function()
    -- motor code goes here
    robotMap.leftIntake:Set(intakePower)
  end,
  IsFinished = function() 
    return not OI.intakeLeftOut:Get() 
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
Execute = function()
  --if readLidar() <= 50 then
 --   robotMap.leftIntake:Set(-intakePower/2)
 -- else
    robotMap.leftIntake:Set(-intakePower)
  --end
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
    robotMap.rightIntake:Set(-intakePower)
  end,
  IsFinished = function() 
    return not OI.intakeRightOut:Get()
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
Execute = function()
 -- if readLidar() <= 50 then
 --     robotMap.rightIntake:Set(intakePower /2)
 -- else
    robotMap.rightIntake:Set(intakePower)
  --  end
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
--Robot.scheduler:AddTrigger(intakeLeftOut)
--Robot.scheduler:AddTrigger(intakeRightOut)
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.intakeLeftOut, intakeLeftOutCommand))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.intakeRightOut, intakeRightOutCommand))

checkWPILib"after intake triggers"
--Robot.scheduler:SetDefaultCommand("intakeWheels",intakeWheelsStopCommand)
--Robot.Teleop.Put("intakeWheels", intakeWheelsStopCommand)
debugPrint("intake finished")

checkWPILib"after debugPrint"