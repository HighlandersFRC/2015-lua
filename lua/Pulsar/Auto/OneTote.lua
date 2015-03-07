-- power time
print("oneTote 1")
local drive = require"Pulsar.Auto.DriveForward"
local turn = require"Pulsar.Auto.SpinTurn"
local intake = require "Pulsar.Auto.intake"


local sequence = require"command.Sequence"
local spin = require "Pulsar.Auto.SpinTurn"
local liftMacro = require "Pulsar.Auto.liftMacro"
local wait = require "command.wait"
local start = require "command.start"
local inOut = require "Pulsar.Auto.moveInOutAuto"
local holding = require "Pulsar.Auto.AutoHolding"

--lifterInOutMax = 14.3,
--lifterInOutMin = 1.5,

print("oneTote 2")

local fullAutonomous = sequence(
  
  liftMacro(22),
  start(intake(-1, 1.5)),
  drive(0.2, 2),
  inOut(RobotConfig.lifterInOutMin, 1),
  liftMacro(0),
  wait(0.25),
  liftMacro(22),
 -- start(holding(22)),
  wait(.2),
  spin(110),
  wait(.2),
  drive(0.3, 3),
  spin(180),
  inOut(50, 1.5),
  start(intake(1, 1.2)),
  wait(.5),
  liftMacro(0),
  wait(.5),
  inOut(1, 1),
  drive(-0.3, 0.45)
  
)
return fullAutonomous