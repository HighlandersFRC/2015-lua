local function seqActInit(self)
    self.actNum = 1
    self.actfin = false
    self.actions[1].Initialize()
end

local function seqActExec(self)
    if self.actNum == 0 then return end
    if self.actfin then
        self.actions[self.actNum].Initialize()
	self.actfin = false
    end
    self.actions[self.actNum].Execute()
    if self.actions[self.actNum].IsFinished() then
        self.actions[self.actNum].End()
	self.actfin = true
        self.actNum = self.actNum + 1
	if self.actNum > #self.actions then
	    self.actNum = 0
	end
    end
end

local function seqActEnd(self)
    if self.actNum == 0 then return end
    self.actions[self.actNum]:End()
end

local function seqActFin(self)
    return self.actNum == 0
end

local function seqActAdd(self, act)
    self.actions[#self.actions + 1] = act
end

local function createSeqAct(...)
    local seqAct = {}
    seqAct.actions = {...}
    seqAct.actNum = 0
    seqAct.actfin = false
    seqAct.Initialize = seqActInit
    seqAct.Execute = seqActExec
    seqAct.End = seqActEnd
    seqAct.IsFinished = seqActFin
    seqAct.Add = seqActAdd
    return seqAct
end

return createSeqAct