local JoystickAxis = require("core.JoystickAxis")
local JoystickButton = require"core.JoystickButton"
local JoystickPOV = require"core.JoystickPOV"

local core = {}

local joysticks = {}

core.getJoy = function(id)
    if joysticks[id] then
        return joysticks[id]
    end
    joysticks[id] = WPILib.Joystick(id)
    return joysticks[id]
end

local joystickButtons = {}

core.getJoyBtn = function(joy, btn)
    if not joystickButtons[joy] then
        joystickButtons[joy] = {}
    end
    if joystickButtons[joy][btn] then
        return joystickButtons[joy][btn]
    end
    joystickButtons[joy][btn] = JoystickButton(core.getJoy(joy), btn)
    return joystickButtons[joy][btn]
end

local joystickAxes = {}

core.getJoyAxis = function(joy, axis)
    if not joystickAxes[joy] then
        joystickAxes[joy] = {}
    end
    if joystickAxes[joy][axis] then
        return joystickAxes[joy][axis]
    end
    joystickAxes[joy][axis] = JoystickAxis(core.getJoy(joy), axis)
    return joystickAxes[joy][axis]
end

core.getJoyPov = function(joy, dir)
  return JoystickPOV(core.getJoy(joy), dir)
end

local talons = {}

core.getTalon = function(id)
    if talons[id] then
        return talons[id]
    end
    talons[id] = WPILib.Talon(id)
    return talons[id]
end

local canTalons = {}
core.getCanTalon = function(id)
    if canTalons[id] then
        return canTalons[id]
    end
    canTalons[id] = WPILib.CANTalon(id)
    return canTalons[id]
end


local AINs = {}

core.getAIN = function(id)
    if AINs[id] then
        return AINs[id]
    end
    AINs[id] = WPILib.AnalogChannel(id)
    return PWMs[id]
end

local DIOs = {}

core.getDIO = function(id)
    if DIOs[id] then
        return DIOs[id]
    end
    DIOs[id] = WPILib.DigitalChannel(id)
    return DIOs[id]
end

local solenoids = {}

core.getSolenoid = function(id)
    if solenoids[id] then
        return solenoids[id]
    end
    solenoids[id] = WPILib.Solenoid(id)
    return solenoids[id]
end

core.setBasicRobot = require "core.compositeRobot"
core.setCompositeRobot = require "core.basicRobot"
core.serialize = require "core.serialize"

local keepAlive_coroutines = {nextIndex = 1}

core.register_keepAlive = function(coro)
  assert(type(coro) == "thread", "argument must be a coroutine")
  table.insert(keepAlive_coroutines, coro)
end

core.notify_keepAlive = function()
  if #keepAlive_coroutines > 0 then
    success, msg = coroutine.resume(keepAlive_coroutines[keepAlive_coroutines.nextIndex])
    if not success then
      print("keep alive coroutine terminated with message ", msg)
    end
    if coroutine.status(keepAlive_coroutines[keepAlive_coroutines.nextIndex]) == "dead" then
      table.remove(keepAlive_coroutines, keepAlive_coroutines.nextIndex)
    else
      keepAlive_coroutines.nextIndex = keepAlive_coroutines.nextIndex + 1
    end
    if keepAlive_coroutines.nextIndex > #keepAlive_coroutines then
      keepAlive_coroutines.nextIndex = 1
    end
  end
end

if MQTT_CONSOLE_ENABLE then
  local MQTT = require"paho.mqtt"

  printCout = print

  local function mqttCallback(topic, payload)
    printCout("mqtt console input", topic, payload)
    -- No console input currently implementedf
    
  end
  
  local mqtt_console_client = MQTT.client.create(MQTT_SERVER_ADDRESS, MQTT_SERVER_PORT, mqttCallback)
  
  mqtt_console_client:connect(MQTT_CONSOLE_ID)
  
  mqtt_console_client:subscribe({MQTT_CONSOLE_TOPIC.."/in"})
  
  function print(...)
    printCout(...)
    mqtt_console_client:publish(MQTT_CONSOLE_TOPIC.."/out", ("%s"):rep(select("#", ...), "\t"):format(...))
  end
  
  function publish(topic, message)
    mqtt_console_client:publish(topic, message)
  end
  
  core.register_keepAlive(
    coroutine.create(
      function()
        while (error_message == nil) do
          error_message = mqtt_console_client:handler()
          coroutine.yield()
        end
      end
    ))
  
  print"MQTT console initialization"
else
  function publish() end
end

return core