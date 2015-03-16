-- power time
local drive = require"Pulsar.Auto.DriveForward"
local turn = require"Pulsar.Auto.SpinTurn"
local intake = require "Pulsar.Auto.intake"
local sequence = require"command.Sequence"
local spin = require "Pulsar.Auto.SpinTurn"
local liftMacro = require "Pulsar.Auto.liftMacro"
local wait = require "command.Wait"
local start = require "command.Start"
local inOut = require "Pulsar.Auto.moveInOutAuto"

--lifterInOutMax = 14.3,
--lifterInOutMin = 1.5,

local fullAutonomous = sequence(
  -- intake -1 is in, 1 is out
  start(liftMacro(14)),
  inOut(1.45),
  wait(.4),
  --wait for e/10 seconds like a boss
  --wait(.271828182845904523536028747135266249775724709369995),
  start(intake(-1, 1.5, .5)),
  drive(0.385, 1.079),
  liftMacro(0.1),
  wait(0.3),
  liftMacro(31),
  --right in front of trashcan
  -- direction, time, power
  start(intake(1, 1.5, 1)),
  wait(0.001),
  start(drive(0.34, 2.5)),
  wait(1.7),
  start(intake(-1, 1.5, 0.5)),
  liftMacro(0.1),
  wait(0.3),
  start(liftMacro(16))
  --[[inOut(1.4),
  --wait for e/10 seconds like a boss
  wait(.271828182845904523536028747135266249775724709369995),
  start(intake(1, 1.5)),
  drive(0.4, 3),
  liftMacro(0),
  liftMacro(16),
  start(intake(-1, 2.5)),
  start(drive(0.4, 6)),
  wait(3.1415926535897932384626433950),
  start(intake(1, 1.5)),
  liftMacro(0),
  start(liftMacro(16)),
  inOut(1.4),
  --wait for e/10 seconds like a boss
  wait(.271828182845904523536028747135266249775724709369995),
  start(intake(1, 1.5)),
  drive(0.4, 3),
  liftMacro(0),
  liftMacro(16),
  start(intake(-1, 2.5)),
  start(drive(0.4, 3)),
  wait(3.1415926535897932384626433950),
  start(intake(1, 1.5)),
  liftMacro(0),
  spin(90),
  drive(0.4, 2.2),
  inOut(14.15),
  start(intake(-1, 2.5)),
  liftMacro(0)--]]
)
return fullAutonomous