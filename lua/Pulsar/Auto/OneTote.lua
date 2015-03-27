-- power time
print("oneTote 1")
local drive = require"Pulsar.Auto.DriveForward"
local turn = require"Pulsar.Auto.SpinTurn"
local intake = require "Pulsar.Auto.intake"


local sequence = require"command.Sequence"
local spin = require "Pulsar.Auto.SpinTurn"
local liftMacro = require "Pulsar.Auto.liftMacro"
local wait = require "command.Wait"
local start = require "command.Start"
local inOut = require "Pulsar.Auto.moveInOutAuto"
local holding = require "Pulsar.Auto.AutoHolding"


local fullAutonomous = sequence(
  
  start(liftMacro(22)),
  wait(.25),
  start(intake(-1, 1.5, .5)),
  drive(0.2, 2),
  start(inOut(RobotConfig.lifterInOutMin)),
  --liftMacro(0,100),
  wait(0.5),
  --liftMacro(22),
  wait(.2),
  spin(110),
  wait(.2),
  drive(0.3, 3.7),
  spin(180),
  --inOut(50, 1.5),
  start(intake(1, 1.2, 1)),
  wait(1),
  --liftMacro(0),
  --inOut(1, 1),
  drive(-0.3, 0.45)
  
)
return fullAutonomous