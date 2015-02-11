local function parActInit(self)
    for _, act in ipairs(self.actions) do
        act:Initialize()
    end
end

local function parActExec(self)
    for _, act in ipairs(self.actions) do
        act:Execute()
    end
end

local function parActEnd(self)
    for _, act in ipairs(self.actions) do
        act:End()
    end
end

local function parActFin(self)
    local fin = true
    for _, act in ipairs(self.actions) do
        fin = act:IsFinished() and fin
    end
    return fin
end

local function parActInterruptible(self)
    if self._interruptible == false then
      return false
    end
    local inter = true
    for _, act in ipairs(self.actions) do
        inter = act:IsInterruptible() and inter
    end
    return inter
end

local function parActAdd(self, act)
    self.actions[#self.actions + 1] = act
end

local function parallelAction(...)
    local parAct = {}
    parAct.actions = {...}
    parAct.Initialize = parActInit
    parAct.Execute = parActExec
    parAct.End = parActEnd
    parAct.IsFinished = parActFin
    parAct.Add = parActAdd
    return parAct
end

return parallelAction