
print"AutoTest"

local core = require "core"
local turn = require "Pulsar.Auto.SpinTurn"
local sequence = require"command.Sequence"
local lidar = require"ArduLidar"
local analogBtn = require"AnalogButton"
local parallel = require"command.Parallel"
local drive = require"Pulsar.Auto.DriveForward"
local lift = require"Pulsar.Auto.lifterUpDown"
local intake = require"Pulsar.Auto.SetIntake"
local setIntake = require "Pulsar.Auto.SetIntake"
local wait = require "command.Wait"
local start = require "command.Start"
robotMap.navX:ZeroYaw()
return sequence(
  start(lift(40)),  
  wait(2),
  start(lift(0)),  
  wait(2),
  start(lift(40)),  
  wait(2)
  
)
