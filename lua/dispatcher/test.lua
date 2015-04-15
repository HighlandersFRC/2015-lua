local dispatcher = require"dispatcher"

local function log_callback(disp, topic, payload)
  if payload:sub(1, 4) == "init" then
    local name = payload:sub(6)
    if name == "" then
      name = topic
    end
    disp:subscribe(topic, function(disp, topic, payload)
        print(("[%s]%s"):format(name, payload))
        return payload == "end"
      end)
  end
end

local disp = dispatcher.create()
disp:subscribe("logger/#", log_callback)

disp:notify("logger/a", "init test")
disp:notify("logger/a", "this is the first message")
disp:notify("logger/b", "init channel B")
disp:notify("logger/a", "this is the second message")
disp:notify("logger/b", "this message is on channel B")
disp:notify("logger/a", "end")
disp:notify("logger/a", "this is the third message")
disp:notify("logger/a", "init test")
disp:notify("logger/b", "end")
disp:notify("logger/a", "this is the fourth message")
disp:notify("logger/a", "end")