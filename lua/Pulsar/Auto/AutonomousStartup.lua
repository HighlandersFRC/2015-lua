print("AutoSys")
--local oneTote = require "Pulsar.AutoSeq"
--local threeTote = require "Pulsar.Auto.threeTote"
local oneTote = require "Pulsar.Auto.oneTote"
local Auto
local autonomous = { 
  Initialize = function()
    Auto = require(autonomousVersion)
    Robot.schedulerAuto:StartCommand(Auto)
  end,
  Execute = function()
    Robot.schedulerAuto:Execute()
  end,
  End = function()
    print("Auto Startup ended")
    Robot.schedulerAuto:CancelCommand(Auto)
  end
}

return autonomous