
local core = require "core"
local turn = require "Pulsar.Auto.SpinTurn"
local sequence = require"command.Sequence"
local lidar = require"ArduLidar"
local analogBtn = require"AnalogButton"
local parallel = require"command.Parallel"
local drive = require"Pulsar.Auto.TriggeredDrive"
local lift = require"Pulsar.Auto.liftMacro"
local intake = require"Pulsar.Auto.SetIntake"

return sequence(
  lift(22),
  parallel(
    --[[drive at 0.3 power  until the lidar reads less than 40 cm
    or 2 seconds have passed]]
    drive(0.3, analogBtn(lidar, 40, true), 2),
    intake(0.5)),
  intake(0)
)
