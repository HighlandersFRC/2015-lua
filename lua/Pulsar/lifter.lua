--Intake Pulsar

--debugPrint("intake started")
local core = require"core"
local lifterPower = 1
local lifterInOutPower = .4
local currentHeight = 0
local pid = require"PID"
local lifterPoint = require"Pulsar.lifterPoint"
local lifterInOutPoint = require"Pulsar.lifterInOut"
local triggers = require"triggers"
local analogButton = require"AnalogButton"
local calibration = require"Pulsar.calibrateEncoders"
-- the lifter lock off means that the arms cannot be moved
robotMap.lifterInOut:SetStatusFrameRateMs(2,20)
robotMap.lifterUpDown:SetStatusFrameRateMs(2,20)
--
-- Intake In Command

local holdPosition = {
  Initialize = function()
    local holdingHeight = (robotMap.lifterUpDown:GetEncPosition()/1000 /25.4 * 120)
    print("Holding Height :",holdingHeight)
    Robot.scheduler:StartCommand(lifterPoint(-robotMap.lifterUpDown:GetEncPosition()/1000 /25.4 * 120))
  end,
  Execute = function()
  end,
  IsFinished = function() 
    return true
  end,
  End = function(self)
  end,
  Interrupted = function(self)
    print"lifterUp has been interrupted"
    self:End()
  end,
  subsystems = {

  },
}
local lifterIn = {
  Initialize = function()
    -- motor code goes here
  end,
  Execute = function()
    print("inOut",robotMap.lifterInOut:Get() )
    if robotMap.lifterInOut:GetEncPosition() <1900 and OI.lifterInOut:Get() < 0 then
      print("moving in",OI.lifterInOut:Get())
      robotMap.lifterInOut:Set(OI.lifterInOut:Get())
    elseif robotMap.lifterInOut:GetEncPosition() > 200  and OI.lifterInOut:Get() > 0 then
      print("moving out")
      robotMap.lifterInOut:Set(OI.lifterInOut:Get())
    else
      --print("not moving")
      --robotMap.lifterInOut:Set(0)
    end

  end,
  IsFinished = function() 
    return (math.abs(OI.lifterInOut:Get()) <.2 )
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

  end,
  Execute = function()
    print("Executing lift",robotMap.lifterUpDown:GetEncPosition()/1000 /25.4 * 120)
    --publish("Robot/Height", robotMap.lifterInOut:GetEncPosition()/1000 /25.4 * 120)
    if (math.abs(robotMap.lifterUpDown:GetEncPosition()/1000 /25.4 * 120) <= RobotConfig.lifterMax and -OI.lifterUpDown:Get() >  0) then
      robotMap.lifterUpDown:Set(-OI.lifterUpDown:Get())
      robotMap.lifterUpDownTwo:Set(-OI.lifterUpDown:Get())
    elseif ((math.abs(robotMap.lifterUpDown:GetEncPosition()/1000 /25.4 * 120)) >= RobotConfig.lifterMin) and ((-OI.lifterUpDown:Get()) <= 0)then
      robotMap.lifterUpDown:Set(-OI.lifterUpDown:Get())
      robotMap.lifterUpDownTwo:Set(-OI.lifterUpDown:Get())
    end
    currentHeight = robotMap.lifterInOut:GetEncPosition()/1000 /25.4 * 120
    print("lifter UpDown One :",robotMap.lifterUpDown:GetOutputCurrent())
    print("lifter UpDown Two :",robotMap.lifterUpDownTwo:GetOutputCurrent())

  end,
  IsFinished = function() 
    return math.abs(OI.lifterUpDown:Get()) <.2 
  end,
  End = function(self)
    robotMap.lifterUpDown:Set(0)
    robotMap.lifterUpDownTwo:Set(0)
    print("Ending")

  end,
  Interrupted = function(self)
    print"lifterUp has been interrupted"
    self:End()
  end,
  subsystems = {
    "LifterUpDown"
  },
}

local lifterUpTrigger = function()
  -- debugPrint("intake in trigger ")
  if math.abs(OI.lifterUpDown:Get()) >=.2 then
    Robot.CurrentScheduler:CancelBySubsystem("LifterUpDown")
    Robot.CurrentScheduler:StartCommand(lifterUp)
  end
end
local lifterInOutTrigger = function()
  -- debugPrint("intake in trigger ")
  if math.abs(OI.lifterInOut:Get()) >=.2 then
    print("OI VALUE IN TRIGGER = ",OI.lifterInOut:Get())
    Robot.CurrentScheduler:CancelBySubsystem("LifterInOut")
    Robot.CurrentScheduler:StartCommand(lifterIn)
  end
end

local zeroPreset = lifterPoint(0)
local outPreset = lifterInOutPoint(15)
local upPreset = lifterPoint(41.5)
local inPreset = lifterInOutPoint(0)



--Robot.scheduler:AddTrigger(triggers.whenPressed(OI.preset,cancel))


--

Robot.scheduler:AddTrigger(lifterInOutTrigger)
--Robot.scheduler:AddTrigger(lifterUpTrigger)
Robot.scheduler:AddTrigger(triggers.whenPressed(analogButton(OI.lifterUpDown,.2),lifterUp))
Robot.scheduler:AddTrigger(triggers.whenPressed(analogButton(OI.lifterUpDown,-.2,true),lifterUp))
Robot.scheduler:AddTrigger(triggers.whenReleased(analogButton(OI.lifterUpDown,.2),holdPosition))
Robot.scheduler:AddTrigger(triggers.whenReleased(analogButton(OI.lifterUpDown,-.2,true),holdPosition))

Robot.scheduler:AddTrigger(triggers.whenPressed(OI.inPreset,inPreset))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.outPreset,outPreset))

Robot.scheduler:AddTrigger(triggers.whenPressed(OI.zeroPreset,zeroPreset))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.topPreset,upPreset))

Robot.scheduler:AddTrigger(triggers.whenPressed(OI.calibrate,calibration()))
--Robot.scheduler:SetDefaultCommand("LifterUpDown",lifterPoint(currentHeight))

--Robot.scheduler:AddTrigger(triggers.whenPressed(OI.presetTwo,cancel))
debugPrint("Lifter Finished")

