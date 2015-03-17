local function parActInit(self)
  for i=1,#self.actions do
    self._actionStates[i] = true
    self.actions[i]:Initialize()
  end
end

local function parActExec(self)
  for i=1,#self.actions do
    if self._actionStates[i] then
      self.actions[i]:Execute()
      if self.actions[i]:IsFinished() then
        self.actions[i]:End()
        self._actionStates[i] = false
      end
    end
  end
end

local function parActEnd(self)
  for i=1,#self.actions do
    if self._actionStates[i] then
      self.actions[i]:End()
      self._actionStates[i] = false
    end
  end
end

local function parActFin(self)
  local fin = true
  for i=1,#self.actions do
    fin = not self._actionStates[i] and fin
  end
  return fin
end

local function subsysUnion(...) 
  local temp = {}
  local args, n = {...}, select("#", ...)
  for a=1, n do
    for i=1, #args[a].subsystems do
      temp[args[a].subsystems[i]]=true
    end
  end
  local result = {}
  for k, v in pairs(temp) do
    table.insert(result, k)
  end
  return result
end

local function parActAdd(self, act)
  self.actions[#self.actions + 1] = act
  self.subsys = subsysUnion(self, act)
end

local function isInterruptible(self)
  if self._interruptible == false then
    return false
  end
  for i=1,#self.actions do
    if self._actionStates[i] and not self.actions[i]:IsInterruptible() then
      return false
    end
  end
  return true
end

local function interrupted(self)
  for i=1,#self.actions do
    if self._actionStates[i] then
      self.actions[i]:Interrupted()
    end
  end
end

local function parallelAction(...)
  local parAct = {}
  parAct.actions = {...}
  parAct._actionStates = {}
  parAct.Initialize = parActInit
  parAct.Execute = parActExec
  parAct.End = parActEnd
  parAct.IsFinished = parActFin
  parAct.IsInterruptible = isInterruptible
  parAct.Interrupted = interrupted
  parAct.Add = parActAdd
  parAct.subsystems = subsysUnion(...)
  return parAct
end

return parallelAction