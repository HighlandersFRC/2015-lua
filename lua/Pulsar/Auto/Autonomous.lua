local sequence = require"command.sequentialAction"
local driveForward = require"Pulsar.PulsarAuto.driveForward"
local arc = require"Pulsar.PulsarAuto.Arc"
local lifterUp = require"Pulsar.PulsarAuto.LifterUpAuto"
local lifterDown = require"Pulsar.PulsarAuto.LifterDownAuto"
local forward = driveForward(.3,3) -- power ,time
local up = lifterUp(1,.4)
local down = lifterDown(.6,.4)
return sequence(up,forward,down,up)