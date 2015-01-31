print("AutoSys")
--local autoTurn = require "Pulsar.PulsarAuto.Turn"
local goForward = require"Pulsar.PulsarAuto.driveForward"
local square = require"Pulsar.PulsarAuto.driveSquareSequnce"
--local sequence = require "AutoSequence"
--local arc = require "Pulsar.PulsarAuto.Arc"
local forward = goForward(0,0)
local core = require"core"
local startTime = 0
local autonomous = { 
  Initialize = function()
    print("autonomous command started")
    --local turn = autoTurn(1,1,1)
    forward = goForward(0,100)
    Robot.schedulerAuto:StartCommand(forward)
    --Robot.schedulerAuto:StartCommand(square)
    --startTime = WPILib.Timer.GetFPGATimestamp()
    --degree speed radius
    --local arcAuto = arc(90,1,15)
    --Robot.schedulerAuto:StartCommand(arcAuto)
   -- Robot.scheduler:StartCommand(sequence)
  end,
  Execute = function()
    Robot.schedulerAuto:Execute()
  end,
  End = function()
    print("Auto Startup ended")
  Robot.schedulerAuto:CancelCommand(forward)
  end
}

return autonomous