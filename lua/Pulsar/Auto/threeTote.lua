-- power time
local drive = require"Pulsar.Auto.DriveForward"
local turn = require"Pulsar.Auto.SpinTurn"
local intake = require "Pulsar.Auto.intake"
local sequence = require"command.Sequence"
local spin = require "Pulsar.Auto.SpinNoGyro"
local liftMacro = require "Pulsar.Auto.liftMacro"
local wait = require "command.wait"
local start = require "command.start"
local inOut = require "Pulsar.moveInOutAuto"

--lifterInOutMax = 14.3,
--lifterInOutMin = 1.5,

local fullAutonomous = sequence(
  start(liftMacro(16)),
  inOut(1.4),
  --wait for e/10 seconds like a boss
  wait(.271828182845904523536028747135266249775724709369995),
  start(intake(1, 1.5)),
  drive(0.4, 3),
  liftMacro(0),
  liftMacro(16),
  start(intake(-1, 2.5),
  start(drive(0.4, 6)),
  wait(3.1415926535897932384626433950),
  start(intake(1, 1.5),
  liftMacro(0),
  start(liftMacro(16)),
  inOut(1.4),
  --wait for e/10 seconds like a boss
  wait(.271828182845904523536028747135266249775724709369995),
  start(intake(1, 1.5)),
  drive(0.4, 3),
  liftMacro(0),
  liftMacro(16),
  start(intake(-1, 2.5),
  start(drive(0.4, 6)),
  wait(3.1415926535897932384626433950),
  start(intake(1, 1.5),
  liftMacro(0),
  start(liftMacro(16)),
  inOut(1.4),
  --wait for e/10 seconds like a boss
  wait(.271828182845904523536028747135266249775724709369995),
  start(intake(1, 1.5)),
  drive(0.4, 3),
  liftMacro(0),
  liftMacro(16),
  start(intake(-1, 2.5),
  start(drive(0.4, 3)),
  wait(3.1415926535897932384626433950),
  start(intake(1, 1.5),
  liftMacro(0),
  spin(0.75),
  drive(0.4, 2.2),
  inOut(14.15),
  start(intake(-1, 2.5),
  liftMacro(0)
)
return fullAutonomous