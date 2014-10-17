function callback(topic,  payload)

  print("mqtt_test:callback(): " .. topic .. ": " .. payload)

  if (payload == "quit") then running = false end
end

local MQTT = require "paho.mqtt"

local mqtt_client = MQTT.client.create("localhost", 4242, callback)

mqtt_client:connect("lua_mqtt_test")

mqtt_client:publish("testtopic", "*** Lua test start ***")
mqtt_client:subscribe({"testtopic"})

local error_message = nil
local running = true

while (error_message == nil and running) do
  error_message = mqtt_client:handler()
end

if (error_message == nil) then
  mqtt_client:unsubscribe({ args.topic_s })
  mqtt_client:destroy()
else
  print(error_message)
end