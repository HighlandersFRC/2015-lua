local commandDefaults = {
  Initialize = function() end,
  Execute = function() end,
  End = function() end,
  Interrupted = function() end,
  IsFinished = function() return true end,
  IsInterruptible = function() return true end,
  subsystems = {}
}

setmetatable(commandDefaults,
  {
    __call = function(commandDefaults, commandData)
      local command = {}
      for k, v in pairs(commandDefaults) do
        command[k] = v
      end
      for k, v in pairs(commandData) do
        command[k] = v
      end
      return commandData
    end
  })
