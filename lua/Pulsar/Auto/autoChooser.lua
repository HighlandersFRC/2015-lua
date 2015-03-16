local core = require"core"
autonomousVersion = "Pulsar.Auto.NoAuto"

local autoChoiceTable = {
  [core.getJoyBtn(0,1)] = "Pulsar.Auto.NoAuto",
  [core.getJoyBtn(0,3)] = "Pulsar.Auto.goForward",
  [core.getJoyBtn(0,2)] = "Pulsar.Auto.OneTote",
  [core.getJoyBtn(0,4)] = "Pulsar.Auto.ThreeTote",
  [core.getJoyBtn(0,10)] = "Pulsar.Auto.AutoTesting"
  
}
local autoChooser = {
  Initialize = function()
  publish("dashboard/autoChooser", autonomousVersion)
  end,
  Execute = function()
    for button , name in pairs(autoChoiceTable) do
      if button:Get() then
        autonomousVersion = name
        print( "Setting Auto TO :", name)
        publish("Robot/AutoChoice", name)
        publish("dashboard/autoChooser", name)
      end 
    end
  end,
  End = function(self)

  end
}

return autoChooser
