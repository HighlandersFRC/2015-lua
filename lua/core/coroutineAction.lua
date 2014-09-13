local function coActInit(self)
    self.corout = coroutine.create(self.cofunc)
    local success, errmsg
    success, errmsg = coroutine.resume(self.corout)
    if not success then error(errmsg) end
end

local function coActExec(self)
    local success, errmsg
    if not self:IsFinished() then
        success, errmsg = coroutine.resume(self.corout)
	print(success, errmsg)
	if not success then error(errmsg) end
    end
end

local function coActEnd(self)
    if self.endfunc then self.endfunc() end
end

local function coActFin(self)
    return coroutine.status(self.corout) == "dead"
end

function coroutineAction(func, endfunc, noRestart)
    local coAct = {}
    coAct.cofunc = func
    coAct.endfunc = endfunc
    coAct.restart = not noRestart
    coAct.corout = nil
    coAct.Initialize = coActInit
    coAct.Execute = coActExec
    coAct.End = coActEnd
    coAct.IsFinished = coActFin
    return coAct
end

return coroutineAction