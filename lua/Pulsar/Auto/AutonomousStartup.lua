print("AutoSys")
--local oneTote = require "Pulsar.AutoSeq"
--local threeTote = require "Pulsar.Auto.threeTote"
local Auto
local autonomous = { 
  Initialize = function()
    Auto = require(autonomousVersion)
    Robot.schedulerAuto:StartCommand(Auto)
    robotMap.navX:ZeroYaw()
    robotMap.BRTalon:ConfigNeutralMode(1) 
    robotMap.BLTalon:ConfigNeutralMode(1) 
    robotMap.FRTalon:ConfigNeutralMode(1) 
    robotMap.FLTalon:ConfigNeutralMode(1) 
    
  end,
  Execute = function()
    Robot.schedulerAuto:Execute()
  end,
  End = function()
    print("Auto Startup ended")
    Robot.schedulerAuto:CancelCommand(Auto)
    robotMap.BRTalon:ConfigNeutralMode(2) 
    robotMap.BLTalon:ConfigNeutralMode(2) 
    robotMap.FRTalon:ConfigNeutralMode(2) 
    robotMap.FLTalon:ConfigNeutralMode(2) 
  end
}

return autonomous