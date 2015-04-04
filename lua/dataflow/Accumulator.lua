local dataflow = require"dataflow"

local accum = {}

function accum:Get()
  local update = dataflow.subtermEvaluator(self.source)
  if update == true then
    update = self.inc
  elseif update == false or update == nil then
    update = self.dec
  end
  self.val = self.val + update
  if self.max and self.val > self.max then
    self.val = self.max
  elseif self.min and self.val < self.min then
    self.val = self.min
  end
  return self.val
end

function accum.newinstance(source, min, max, inc, dec)
  local self = {source = source, min = min, max = max, inc = inc or 1, dec = dec or -1, val = 0, Get=accum.Get}
  setmetatable(self, dataflow.metatable)
  return self
end

setmetatable(accum, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return accum