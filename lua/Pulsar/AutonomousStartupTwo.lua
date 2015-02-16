print("AutoSys")
--local threeTotes = require"Pulsar.Auto.ThreeTotes"
local core = require "core"
local intake = require"Pulsar.Auto.intake"
local lifterUp = require"Pulsar.Auto.lifterUp"
local lifterDown = require"Pulsar.Auto.lifterDown"
local sequence = require "command.Sequence"
--local intakeSequence = require"Pulsar.Auto.intakeSequence"
local drive = require "Pulsar.Auto.DriveForward"
local spin = require "Pulsar.Auto.noGyroSpin"
local wait = require "command.wait"
local inOut = require "Pulsar.Auto.moveInOut"
local liftMacro = require "Pulsar.Auto.liftMacro"
local setVal = inOut(10)
--drive forward uses power time

local intakeSequence = sequence(
  liftMacro(22),
  drive(0.2, 0.5),
  liftMacro(0),
  liftMacro(22)
  --lifterUp(),
  --lifterDown()
)
local ghettoAutonomous = sequence(

  liftMacro(22),
  intake(),
  intakeSequence,
  wait(1),
  spin(0.7),
  drive(0.5, 2.5),
  liftMacro(0)
)


local autonomous = { 
  Initialize = function()
    local fullIntake = sequence(
      intakeSequence
    )

    local inOutAutoTest = sequence (
      inOut(1),
      wait(0.4),
      inOut(-1),
      wait(0.4),
      inOut(1),
      wait(0.4),
      inOut(-1),
      wait(0.4),
      inOut(1),
      wait(0.4),
      inOut(-1),
      wait(0.4),
      inOut(1),
      wait(0.4),
      inOut(-1),
      wait(0.4),
      inOut(0)
    )

    print("autonomous command started")
    local fullAutonomous = sequence(
      drive(0.1,0.3),
      --intakeSequence,
      wait(1),
      drive(-0.1,0.5),
      spin(0.2),
      drive(0.3, 2.5),
      spin(-0.2),
      drive(0.1, 0.3),
      --intakeSequence,
      wait(1),
      drive(-0.1,0.5),
      spin(0.2),
      drive(0.5, 1.5),
      spin(-0.2),
      drive(0.1, 0.3),
      --intakeSequence,
      wait(1),
      drive(-0.1,0.5),
      spin(0.2)
    )

    local turns = sequence (
      spin(0.2),
      spin(-0.2),
      spin(0.2),
      spin(-0.2)

    )  

    Robot.schedulerAuto:StartCommand(ghettoAutonomous)
  end,
  Execute = function()
    Robot.schedulerAuto:Execute()
  end,
  End = function()
    print("Auto Startup ended")
    Robot.schedulerAuto:CancelCommand(ghettoAutonomous)
    --Robot.schedulerAuto:StartCommand(intake())
  end
}

return autonomous