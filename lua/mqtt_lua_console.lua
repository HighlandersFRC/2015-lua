local function formatReturn(value)
  local t = type(value)
  if t == "table" then
    local entries = {}
    for k, v in pairs(value) do
      table.insert(entries, ("%s:%s"):format(formatReturn(k), formatReturn(v)))
    end
    return "{"..table.concat(entries, ", ").."}"
  end
  if t == "string" then
    return ("%q"):format(value)
  end
  return tostring(value)
end

local mqtt_client

local function callback(topic,  payload)

  print("mqtt_lua_console:callback(): " .. topic .. ": " .. payload)
  
  if topic == "lua/console" then
    if payload:sub(1, 5) == "code:" then
      print("mqtt_lua>"..payload:sub(6))
      mqtt_client:publish("lua/console", "return: "..formatReturn(load(payload:sub(6))()))
    end
  end
  

  if (payload == "quit") then running = false end
end

local MQTT = require "paho.mqtt"

local function start()
  
  mqtt_client = MQTT.client.create(MQTT_SERVER_ADDRESS, MQTT_SERVER_PORT, callback)

  mqtt_client:connect("lua_mqtt_console")

  mqtt_client:publish("lua/console", "*** Starting Lua Console ***")
  mqtt_client:subscribe({"lua/console"})
  
  register_keepAlive(
    coroutine.create(
      function()
        local error_message = nil
        local running = true
        
        while (error_message == nil and running) do
          error_message = mqtt_client:handler()
          coroutine.yield()
        end

        if (error_message == nil) then
          mqtt_client:unsubscribe({"lua/console"})
          mqtt_client:destroy()
        else
          print(error_message)
        end
      end
    )
  )
end

return {start = start}