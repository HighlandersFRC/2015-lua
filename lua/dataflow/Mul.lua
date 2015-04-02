local dataflow = require"dataflow"

local Mul = {}

function Mul:Get()
  local accum = dataflow.subtermEvaluator(self.terms[1])
  for i=2, #self.terms do
    accum = accum * dataflow.subtermEvaluator(self.terms[i])
  end
  return accum
end

Mul.metatable = {__index = Mul}

function Mul.newinstance(...)
  local self = {terms = {...}}
  setmetatable(self, Mul.metatable)
  return self
end

setmetatable(Mul, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return Mul