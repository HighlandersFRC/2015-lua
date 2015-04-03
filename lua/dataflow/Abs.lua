local dataflow = require"dataflow"

local Abs = {}

function Abs:Get()
  return math.abs(dataflow.subtermEvaluator(self.expr))
end

Abs.metatable = {}

for k, v in pairs(dataflow.metatable) do
  Abs.metatable[k] = v
end
Abs.metatable.__index = Add

function Abs.newinstance(expr)
  local self = {expr = expr}
  setmetatable(self, Abs.metatable)
  return self
end

setmetatable(Abs, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return Abs