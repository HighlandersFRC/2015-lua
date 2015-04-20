local core = require "core"
local lifter = require "Pulsar.lifter"
core.register_keepAlive(
  coroutine.create(
    function()
      while true do 
        publish("Robot/LifterUpDown/Current", tostring(robotMap.lifterUpDown:GetOutputCurrent()))
        --publish("Robot/LifterUpDownTwo/Current", tostring(robotMap.lifterUpDownTwo:GetOutputCurrent()))
        publish("Robot/LifterUpDown/Voltage", tostring(robotMap.lifterUpDown:GetOutputVoltage()))
        --print("DriveFR Output Voltage "..robotMap.FRTalon:GetOutputVoltage())
        --publish("Robot/LifterUpDownTwo/Voltage", tostring(robotMap.lifterUpDownTwo:GetOutputVoltage()))
        publish("dashboard/lifterPos", tostring(lifter.position:Get()))
        publish("dashboard/lifterInOutPos", tostring(lifter.inOutPosition:Get()))
        coroutine.yield()
      end
    end))

