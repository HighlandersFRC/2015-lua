local subsysUnion = require"command.group".subsysUnion

local cond = {}

function cond:Initialize()
  for i = 1, #self.commands, 1 do
    if self.conditions[i] then
      if self.conditions[i]:Get() then
        self.chosenCommand = self.commands[i]
        break
      end
    else
      self.chosenCommand = self.commands[i]
      break
    end
  end
  self.chosenCommand:Initialize()
end

function cond:Execute()
  self.chosenCommand:Execute()
end

function cond:End()
  self.chosenCommand:End()
end

function cond:Interrupted()
  self.chosenCommand:Interrupted()
end

function cond:IsFinished()
  return self.chosenCommand:IsFinished()
end

function cond:IsInterruptible()
  return cond.chosenCommand:IsInterruptible()
end

cond.metatable = {
  __index = cond
}

function cond.newinstance(cond, cmd, ...)
  assert(cond, "no condition provided")
  assert(cmd, "no command provided")
  local commands = {}
  local conditions = {}
  commands[1] = cmd
  conditions[1] = cond
  local pairsCount = select("#", ...)
  pairsCount = pairsCount - pairsCount%2
  for i = 0, pairsCount, 2 do
    cond, cmd = select(i, ...)
    assert(cond, "no condition provided")
    assert(cmd, "no command provided")
    table.insert(commands, cmd)
    table.insert(conditions, cond)
  end
  cmd = select(pairsCount*2, ...)
  table.insert(commands, cmd)
  local self = {}
  self.commands = commands
  self.conditions = conditions
  setmetatable(self, cond.metatable)
  return self
end

setmetatable(cond, {
    __call = function(class, ...) return class.newinstance(...) end
  })