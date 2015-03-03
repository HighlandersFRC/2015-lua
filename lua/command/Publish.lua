return function(topic, message)
  local publishCommand = {topic = topic, message = message, subsys = {}}

  function publishCommand:Initialize()
    publish(self.topic, self.message)
  end
  function publishCommand:Execute()
    --do nothing
  end
  function publishCommand:End()
    --do nothing
  end
  function publishCommand:Interrupted()
    --do nothing
  end
  function publishCommand:IsFinished()
    return true
  end
  function publishCommand:IsInterruptible()
    return true
  end
  return publishCommand
end