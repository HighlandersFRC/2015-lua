return function(count, cmd)
  local repeatCmd = {targetCount = count, command = cmd, subsys = cmd.subsys}
  function repeatCmd:Initialize()
    self.count = 0
    self.command:Initialize()
  end
  function repeatCmd:Execute()
    self.command:Execute()
    if self.command:IsFinished() then
      self.count = self.count + 1
      if self.count < self.targetCount then
        self.command:End()
        self.command:Initialize()
      end
    end
  end
  function repeatCmd:End()
    self.command:End()
  end
  function repeatCmd:Interrupted()
    self.command:Interrupted()
  end
  function repeatCmd:IsFinished()
    return self.count >= self.targetCount
  end
  function repeatCmd:IsInterruptible()
    return self.command:IsInterruptible()
  end
  return repeatCmd
end