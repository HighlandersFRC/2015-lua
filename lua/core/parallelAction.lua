local function parActInit(self)
    for act in self.actions do
        act.Initialize()
    end
end

local function parActExec(self)
    for act in self.actions do
        act.Execute()
    end
end

local function parActEnd(self)
    for act in self.actions do
        act.End()
    end
end

local function parActFin(self)
    local fin = true
    for act in self.actions do
        fin = act.IsFinished() and fin
    end
    return fin
end

local function parActAdd(self, act)
    self.actions[#self.actions + 1] = act
end

local function parallelAction(...)
    parAct = {}
    parAct.actions = {...}
    parAct.Initialize = parActInit
    parAct.Execute = parActExec
    parAct.End = parActEnd
    parAct.IsFinished = parActFin
    parAct.Add = parActAdd
    return parAct
end

return parallelAction