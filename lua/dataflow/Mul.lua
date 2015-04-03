local dataflow = require"dataflow"

local Mul = {}

function Mul:Get()
  local accum = dataflow.subtermEvaluator(self.terms[1])
  for i=2, #self.terms do
    accum = accum * dataflow.subtermEvaluator(self.terms[i])
  end
  return accum
end

Mul.metatable = {}

for k, v in pairs(dataflow.metatable) do
  Mul.metatable[k] = v
end
Mul.metatable.__index = Add

function Mul.newinstance(...)
  local self = {terms = {...}}
  setmetatable(self, Mul.metatable)
  return self
end

setmetatable(Mul, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return Mul