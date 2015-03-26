print("AutoSys")
--local oneTote = require "Pulsar.AutoSeq"
--local threeTote = require "Pulsar.Auto.threeTote"
local Auto
local autoDriveNeutral = 1
local autonomous = { 
  Initialize = function()
    Auto = require(autonomousVersion)
    robotMap.navX:ZeroYaw()
    Robot.schedulerAuto:StartCommand(Auto)
    robotMap.BRTalon:ConfigNeutralMode(autoDriveNeutral) 
    robotMap.BLTalon:ConfigNeutralMode(autoDriveNeutral) 
    robotMap.FRTalon:ConfigNeutralMode(autoDriveNeutral) 
    robotMap.FLTalon:ConfigNeutralMode(autoDriveNeutral) 

  end,
  Execute = function()
    Robot.schedulerAuto:Execute()
  end,
  End = function()
    print("Auto Startup ended")
    Robot.schedulerAuto:CancelCommand(Auto)
    robotMap.BRTalon:ConfigNeutralMode(1) 
    robotMap.BLTalon:ConfigNeutralMode(1) 
    robotMap.FRTalon:ConfigNeutralMode(1) 
    robotMap.FLTalon:ConfigNeutralMode(1) 
  end
}

return autonomous