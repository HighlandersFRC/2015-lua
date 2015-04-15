local handlers = {}

function handlers.ignoreFirst(handler)
  return function(disp, topic, payload)
    return handler
  end
end

function handlers.printer(friendlyName)
  if friendlyName then
    if friendlyName == "" then
      return function(disp, topic, payload)
        print(("[%s] %s"):format(topic, payload))
      end
    else
      local printFmt = ("[%s]%%s"):format(friendlyName)
      return function(disp, topic, payload)
        print(printFmt:format(payload))
      end
    end
  else
    return function(disp, topic, payload)
      print(payload)
    end
  end
end

function handlers.writer(handle, friendlyName)
  if friendlyName then
    if friendlyName == "" then
      return function(disp, topic, payload)
        handle:write(("[%s] %s"):format(topic, payload))
      end
    else
      local printFmt = ("[%s]%%s"):format(friendlyName)
      return function(disp, topic, payload)
        handle:write(printFmt:format(payload))
      end
    end
  else
    return function(disp, topic, payload)
      handle:write(payload)
    end
  end
end