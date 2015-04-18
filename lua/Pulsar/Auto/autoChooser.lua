local core = require"core"
local btn = core.getJoyBtn
local And = require"dataflow.And"
local Not = require"dataflow.Not"
local parallel = require "command.Parallel"
local chaseVision = require"Pulsar.Auto.ChaseVision"
local liftMacro = require "Pulsar.Auto.lifterUpDown"
autonomousVersion = "Pulsar.Auto.NoAuto"

local autoAlt = btn(2,8)
local autoChoiceTable = {
  [btn(2,1)] = "Pulsar.Auto.NoAuto",
  [btn(2,2)] = "Pulsar.Auto.goForward",
  [btn(2,3)] = "Pulsar.Auto.OneTote",
  [And(btn(2,4), Not(autoAlt))] = "Pulsar.Auto.ThreeToteRight",
  [And(btn(2,4), autoAlt)] = "Pulsar.Auto.ThreeToteLeft",
  --[btn(2,4)] = "Pulsar.Auto.ThreeToteRight",
   [And(btn(2,5), Not(autoAlt))] = "Pulsar.Auto.AutoTesting",
    [And(btn(2,5), autoAlt)] = "Pulsar.Auto.TestChaseVision"
}
local autoLastTime = 0
local autoChooser = {
  Initialize = function()
    publish("dashboard/autoChooser", autonomousVersion)
  end,
  Execute = function()
    for button , name in pairs(autoChoiceTable) do
      if button:Get() then
        if name ~= autonomousVersion then
          autonomousVersion = name
          print( "Setting Auto TO :", name)
          publish("Robot/AutoChoice", name)
          publish("dashboard/autoChooser", name)
          autoLastTime = WPILib.Timer.GetFPGATimestamp()
        end
      end
    end
    if autoLastTime + 0.2 <= WPILib.Timer.GetFPGATimestamp() then
      publish("Robot/AutoChoice", autonomousVersion)
      publish("dashboard/autoChooser", autonomousVersion)
      autoLastTime = WPILib.Timer.GetFPGATimestamp()
    end
  end,
  End = function(self)

  end
}

return autoChooser
