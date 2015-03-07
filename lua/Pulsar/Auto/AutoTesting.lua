
local core = require "core"
local turn = require "Pulsar.Auto.SpinTurn"
local sequence = require"command.Sequence"
local drive = require"Pulsar.Auto.DriveForward"
local justTurn = sequence (
    turn(90),
    drive(.1,3),
    turn(180),
    drive(.1,3),
    turn(-90),
    drive(.1,3),
    turn(0),
    drive(.1,3)
    
  )
  return justTurn
