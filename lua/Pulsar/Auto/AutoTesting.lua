
print"AutoTest"

local core = require "core"
local turn = require "Pulsar.Auto.SpinTurn"
local sequence = require"command.Sequence"
local lidar = require"ArduLidar"
local analogBtn = require"AnalogButton"
local parallel = require"command.Parallel"
local drive = require"Pulsar.Auto.DriveForward"
local lift = require"Pulsar.Auto.liftMacro"
local intake = require"Pulsar.Auto.SetIntake"
robotMap.navX:ZeroYaw()
return sequence(
drive(.7,2.5)
)
