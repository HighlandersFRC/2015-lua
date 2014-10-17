-- This code sets up core functions and data for the Lua Robot.
-- It must never be ran more than once per run.
-- It is run automatically on boot.
-- It should usually not be modified.

print("beginning lua core initialization")

package.path = "/lua/core/?.lua;/lua/?.lua"

dofile"/lua/core/defaultConfig.lua"

dofile"/lua/config.lua"

local joysticks = {}

function getJoy(id)
    if joysticks[id] then
        return joysticks[id]
    end
    joysticks[id] = WPILib.Joystick(WPILib.asUint32(id))
    return joysticks[id]
end

local joystickButtons = {}

function getJoyBtn(joy, btn)
    if not joystickButtons[joy] then
        joystickButtons[joy] = {}
    end
    if joystickButtons[joy][btn] then
        return joystickButtons[joy][btn]
    end
    joystickButtons[joy][btn] = WPILib.JoystickButton(getJoy(joy), btn)
    return joystickButtons[joy][btn]
end

local talons = {}

function getTalon(id)
    if talons[id] then
        return talons[id]
    end
    talons[id] = WPILib.Talon(WPILib.asUint32(id))
    return talons[id]
end

local AINs = {}

function getAIN(id)
    if AINs[id] then
        return AINs[id]
    end
    AINs[id] = WPILib.AnalogChannel(WPILib.asUint32(id))
    return PWMs[id]
end

local DIOs = {}

function getDIO(id)
    if DIOs[id] then
        return DIOs[id]
    end
    DIOs[id] = WPILib.DigitalChannel(WPILib.asUint32(id))
    return DIOs[id]
end

local solenoids = {}

function getSolenoid(id)
    if solenoids[id] then
        return solenoids[id]
    end
    solenoids[id] = WPILib.Solenoid(WPILib.asUint32(id))
    return solenoids[id]
end

setCompositeRobot = dofile("/lua/core/compositeRobot.lua")

setBasicRobot = dofile("/lua/core/basicRobot.lua")

coAction = dofile("/lua/core/coroutineAction.lua")

seqAction = dofile("/lua/core/sequentialAction.lua")

parAction = dofile("/lua/core/parallelAction.lua")

serialize = dofile("/lua/core/serialize.lua")

local keepAlive_coroutines = {nextIndex = 1}

function register_keepAlive(coro)
  assert(type(coro) == "thread", "argument must be a coroutine")
  table.insert(keepAlive_coroutines, coro)
end

function notify_keepAlive()
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
    if keepAlive_coroutines.nextIndex >= #keepAlive_coroutines then
      keepAlive_coroutines.nextIndex = 1
    end
  end
end

if MQTT_CONSOLE_ENABLE then
  local MQTT = require"paho.mqtt"

  printCout = print

  local function mqttCallback(topic, payload)
    -- No console input currently implemented
  end
  
  local mqtt_console_client = MQTT.client.create(MQTT_SERVER_ADDRESS, MQTT_SERVER_PORT, mqttCallback)
  
  mqtt_console_client:connect(MQTT_CONSOLE_ID)
  
  mqtt_console_client:subscribe({MQTT_CONSOLE_TOPIC})
  
  function print(...)
    printCout(...)
    mqtt_console_client:publish(MQTT_CONSOLE_TOPIC, ("%s"):rep(select("#", ...), "\t"):format(...))
  end
  
  register_keepAlive(
    coroutine.create(
      function()
        while (error_message == nil) do
          error_message = mqtt_console_client:handler()
          coroutine.yield()
        end
      end
    ))
  
  print"MQTT console initialization"
end


print("finished lua core initialization")