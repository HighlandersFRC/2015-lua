local dataflow = require"dataflow"

local Not = {}

function Not:Get()
  return not dataflow.subtermEvaluator(self.expr)
end

Not.metatable = {}

for k, v in pairs(dataflow.metatable) do
  Not.metatable[k] = v
end
Not.metatable.__index = Not

function Not.newinstance(expr)
  local self = {expr = expr}
  setmetatable(self, Not.metatable)
  return self
end

setmetatable(Not, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return Not