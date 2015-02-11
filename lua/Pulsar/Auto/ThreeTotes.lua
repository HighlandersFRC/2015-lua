local drive = require"Pulsar.Auto.DriveForward"
local turn = require"Pulsar.Auto.SpinTurn"
local intake = require"Pulsar.Auto.SetIntake"
local sequence = require"command.Sequence"

local threeTotes = sequence(
  --intake(1),
  turn(45)
  --intake(0),
  --drive(0.5, 0.2)
)

return threeTotes