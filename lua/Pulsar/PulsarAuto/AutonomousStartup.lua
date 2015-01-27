print("AutoSys")
--local autoTurn = require "Pulsar.PulsarAuto.Turn"
local goForward = require"Pulsar.PulsarAuto.driveForward"
local sequence = require "AutoSequence"
--local arc = require "Pulsar.PulsarAuto.Arc"
local core = require"core"
local autonomous = { 
  Initialize = function()
    print("autonomous command started")
    --local turn = autoTurn(1,1,1)
    Robot.schedulerAuto:StartCommand(goForward)
    --degree speed radius
    --local arcAuto = arc(90,1,15)
    --Robot.schedulerAuto:StartCommand(arcAuto)
   -- Robot.scheduler:StartCommand(sequence)
  end,
  Execute = function()
    Robot.schedulerAuto:Execute()
  end,
  End = function()

  end
}

return autonomous