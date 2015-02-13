local intake = require "intake"
local core = require "core"
local lifterUp = require "lifterUp"
local lifterDown = require "lifterDown"
local sequence = require "command.sequence"

local intakeSequence = sequence(
  
  intake(),
  lifterUp(),
  lifterDown()
  
)

return intakeSequence