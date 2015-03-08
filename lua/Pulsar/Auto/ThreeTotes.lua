local drive = require"Pulsar.Auto.DriveForward"
local turn = require"Pulsar.Auto.SpinTurn"
local intake = require "Pulsar.Auto.intake"
local sequence = require"command.Sequence"
local spin = require "Pulsar.Auto.SpinTurn"
local liftMacro = require "Pulsar.Auto.liftMacro"
local wait = require "command.wait"
local start = require "command.start"
local inOut = require "Pulsar.Auto.moveInOutAuto"
local threeTotes = sequence(
  
  liftMacro(22),
  start(intake(-1, 1)),
  drive(0.2, 0.7),
  inOut(1, 1),
  liftMacro(0),
  wait(0.25),
  liftMacro(22),
  wait(.2),
  spin(45),
  wait(.2),
  drive(0.3, 3),
  spin(-45),
  inOut(50, 1.5),
  start(intake(1, 1.2)),
  liftMacro(0),
  inOut(1, 1),
  drive(-0.3, 0.45)
  
)

return threeTotes