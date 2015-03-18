return function(...)
  local printCommand = {vals = {...}, subsystems = {}}

  function printCommand:Initialize()
    print(table.unpack(self.vals))
  end
  function printCommand:Execute()
    --do nothing
  end
  function printCommand:End()
    --do nothing
  end
  function printCommand:Interrupted()
    --do nothing
  end
  function printCommand:IsFinished()
    return true
  end
  function printCommand:IsInterruptible()
    return true
  end
  return printCommand
end