local core = require"core"
autonomousVersion = "Pulsar.Auto.NoAuto"

local autoChoiceTable = {
  [core.getJoyBtn(2,1)] = "Pulsar.Auto.NoAuto",
  [core.getJoyBtn(2,2)] = "Pulsar.Auto.goForward",
  [core.getJoyBtn(2,3)] = "Pulsar.Auto.OneTote",
  [core.getJoyBtn(2,4)] = "Pulsar.Auto.ThreeTote",
  [core.getJoyBtn(2,5)] = "Pulsar.Auto.AutoTesting"

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
