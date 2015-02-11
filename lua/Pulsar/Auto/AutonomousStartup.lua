print("AutoSys")
local threeTotes = require"Pulsar.Auto.ThreeTotes"
local autonomous = { 
  Initialize = function()
    print("autonomous command started")
    Robot.schedulerAuto:StartCommand(threeTotes)
  end,
  Execute = function()
    Robot.schedulerAuto:Execute()
  end,
  End = function()
    print("Auto Startup ended")
    Robot.schedulerAuto:CancelCommand(threeTotes)
  end
}

return autonomous