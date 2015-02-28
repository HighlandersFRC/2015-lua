
local core = require "core"
local drive = require "Pulsar.Auto.DriveForward"
local sequence = require"command.Sequence"
local justDrive = sequence (
    drive(0.4, 2.2)
  )
  return justDrive
