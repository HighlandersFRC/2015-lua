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
local tailPos = require"Pulsar.TailPosition"
local parallel = require"command.Parallel"
local start = require"command.Start"
local sequence = require"command.Sequence"
local wait = require"command.Wait"
local trigWait = require"command.TriggerWait"
local dataflow = require"dataflow"
local Compare = require"dataflow.Compare"
local lifterInOutCalibration = require"Pulsar.CalibrateInOut"
-- the lifter lock off means that the arms cannot be moved
robotMap.lifterInOut:SetStatusFrameRateMs(2,20)
robotMap.lifterUpDown:SetStatusFrameRateMs(2,20)
--
-- Intake In Command
local clamp = function(inputValue)
  if inputValue >=RobotConfig.lifterClamp then
    return RobotConfig.lifterClamp
  elseif inputValue <= RobotConfig.lifterClampDown then
    return RobotConfig.lifterClampDown
  else
    return inputValue
  end
end
local adjustStall = function()
  local current = robotMap.lifterUpDown:GetOutputCurrent()*(robotMap.lifterUpDown:GetBusVoltage() /robotMap.lifterUpDown:GetOutputVoltage())
      -- this expression is used to avoid cases where current spikes = inf
      if math.abs(robotMap.lifterUpDown:GetOutputVoltage()) == 0 then
        current = -100
        end
      RobotConfig.lifterClampDown = math.min(-.05,(robotMap.lifterUpDown:GetOutputVoltage() - (current/RobotConfig.lifterKi) + (RobotConfig.lifterDownCurrentLimit/RobotConfig.lifterKi)) / robotMap.lifterUpDown:GetBusVoltage())

  end
local function inch2tickUD(val)
  return -val * 25.4 /120 * 1000
end
local function tick2inchUD(val)
  return -val /1000 /25.4 *120
end

local holdPosition = {
  Initialize = function()
    local holdingHeight = (robotMap.lifterUpDown:GetPosition()/1000 /25.4 * 120)
    print("Holding Height :",holdingHeight)
    Robot.scheduler:StartCommand(lifterPoint(-robotMap.lifterUpDown:GetPosition()/1000 /25.4 * 120))
  end,
  Execute = function()
  end,
  IsFinished = function() 
    return true
  end,
  End = function(self)
  end,
  Interrupted = function(self)
    print"lifter Hold has been interrupted"
    self:End()
  end,
  subsystems = {
    "LifterUpDown"
  },
}
local lifterIn = {
  Initialize = function()
    print("started Lifter In")
  end,
  Execute = function()
    if not OI.lifterInOutDisable:Get() then
      print("inOut",robotMap.lifterInOut:Get() )
      if robotMap.lifterInOut:GetPosition() <1900 and OI.lifterInOut:Get() < 0 then
        print("moving in",OI.lifterInOut:Get())
        robotMap.lifterInOut:Set(OI.lifterInOut:Get())
      elseif robotMap.lifterInOut:GetPosition() > 200  and OI.lifterInOut:Get() > 0 then
        print("moving out")
        robotMap.lifterInOut:Set(OI.lifterInOut:Get())
      else
        --print("not moving")
        robotMap.lifterInOut:Set(0)
      end
    else

      print("moving in",OI.lifterInOut:Get())
      robotMap.lifterInOut:Set(OI.lifterInOut:Get())
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
    
    
   adjustStall()
    
    
    local position = tick2inchUD(robotMap.lifterUpDown:GetPosition())
    if (position <= RobotConfig.lifterMax and -OI.lifterUpDown:Get() >  0) then
      local pwr = math.min(-OI.lifterUpDown:Get(), (RobotConfig.lifterMax - position) / 6)
      robotMap.lifterUpDown:Set(pwr)
      --print("setting lifter power up to ".. tostring(pwr).. " input ".. tostring(OI.lifterUpDown:Get()).. " ramp "..tostring((RobotConfig.lifterMax - position) / 6))
      -- robotMap.lifterUpDownTwo:Set(-OI.lifterUpDown:Get())
    elseif (position >= RobotConfig.lifterMin) and ((-OI.lifterUpDown:Get()) <= 0)then
      local pwr = -math.min(OI.lifterUpDown:Get(), -(RobotConfig.lifterMin - position) / 6)
      robotMap.lifterUpDown:Set(clamp(pwr))
      -- print("setting lifter power down to "..tostring(pwr).." input "..tostring(OI.lifterUpDown:Get()).." ramp "..tostring(-(position - RobotConfig.lifterMin) / 6))
      --robotMap.lifterUpDownTwo:Set(-OI.lifterUpDown:Get())
    else
      robotMap.lifterUpDown:Set(0)
    end
    currentHeight = robotMap.lifterInOut:GetPosition()/1000 /25.4 * 120
    print("lifter UpDown One :",robotMap.lifterUpDown:GetOutputCurrent())
    --print("lifter UpDown Two :",robotMap.lifterUpDownTwo:GetOutputCurrent())

  end,
  IsFinished = function() 
    return math.abs(OI.lifterUpDown:Get()) <.2 
  end,
  End = function(self)
    robotMap.lifterUpDown:Set(0)
    -- robotMap.lifterUpDownTwo:Set(0)
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

local function SetLift(power, target)
  return {
    Initialize = function()
      print"initialized SetLift"
    end,
    Execute = function()
     if not OI.lifterUpDownDisable:Get() then
      robotMap.lifterUpDown:Set(power)
      end
    end,
    End = function()
      robotMap.lifterUpDown:Set(0)
    end,
    Interrupted = function(self)
      self:End()
    end,
    IsFinished = function()
      if power > 0 then
        return tick2inchUD(robotMap.lifterUpDown:GetPosition()) >= target
      else
        return tick2inchUD(robotMap.lifterUpDown:GetPosition()) <= target
      end
    end,
    subsystems = {"LifterUpDown"}
  }
end

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
    --print("OI VALUE IN TRIGGER = ",OI.lifterInOut:Get())
    Robot.CurrentScheduler:CancelBySubsystem("LifterInOut")
    Robot.CurrentScheduler:StartCommand(lifterIn)
  end
end

local lifterPos = dataflow.wrap(function() return tick2inchUD(robotMap.lifterUpDown:GetPosition()) end)

local zeroPreset = parallel(lifterPoint(0), start(sequence(wait(0.25), tailPos(65))))
local outPreset = lifterInOutPoint(15)
local upPreset = parallel(start(lifterPoint(100)), start(tailPos(52)))
local inPreset = lifterInOutPoint(0)
local canPreset = parallel(start(lifterPoint(34)), start(tailPos(80)))
--parallel(lifterPoint(15), sequence(trigWait(function() return tick2inchUD(robotMap.lifterUpDown:GetPosition()) <= 16 end), lifterInOutPoint(14)))

local landfillTotePreset = lifterPoint(17)
local landfillToteSeq = sequence(require"command.Print"("running landfill tote sequence"), SetLift(-1, RobotConfig.lifterMin+4.5), SetLift(-0.3, RobotConfig.lifterMin+0.7), SetLift(0.5, 3), landfillTotePreset)

local humanFeedTotePreset = lifterPoint(27)
local humanFeedToteSeq = sequence(require"command.Print"("running human feeder tote sequence"), SetLift(-1, RobotConfig.lifterMin+4.5), SetLift(-0.3, RobotConfig.lifterMin+0.7), trigWait(Compare(lifterPos, "<", RobotConfig.lifterMin + 0.25)), wait(0.1), SetLift(0.5, 3), humanFeedTotePreset)


--Robot.scheduler:AddTrigger(triggers.whenPressed(OI.preset,cancel))


--

--Robot.scheduler:AddTrigger(lifterInOutTrigger)
--these are the triggers for the inout command
Robot.scheduler:AddTrigger(triggers.whenPressed(analogButton(OI.lifterInOut,.2),lifterIn))
Robot.scheduler:AddTrigger(triggers.whenPressed(analogButton(OI.lifterInOut,-.2,true),lifterIn))

-- these are the triggers for the main lifter up Down 
Robot.scheduler:AddTrigger(triggers.whenPressed(analogButton(OI.lifterUpDown,.2),lifterUp))
Robot.scheduler:AddTrigger(triggers.whenPressed(analogButton(OI.lifterUpDown,-.2,true),lifterUp))
--Robot.scheduler:AddTrigger(triggers.whenReleased(analogButton(OI.lifterUpDown,.2),holdPosition))
--Robot.scheduler:AddTrigger(triggers.whenReleased(analogButton(OI.lifterUpDown,-.2,true),holdPosition))
-- these are the triggers for the in and out presets
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterInPreset,inPreset))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterOutPreset,outPreset))
-- these are the triggers for the lifter setpoint presets
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterBottomPreset,zeroPreset))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterTopPreset,upPreset))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterCanPreset,canPreset))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterLandfillTotePreset,landfillTotePreset))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterLandfillToteSeq,landfillToteSeq))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterHumanFeedTotePreset,humanFeedTotePreset))
Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterHumanFeedToteSeq,humanFeedToteSeq))


Robot.scheduler:AddTrigger(triggers.whenPressed(OI.lifterCalibrate,parallel(calibration(), require"command.Print"("triggered calibration sequence"),lifterInOutCalibration())))

Robot.scheduler:SetDefaultCommand("LifterUpDown",holdPosition)
debugPrint("Lifter Finished")