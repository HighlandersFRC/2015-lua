local dataflow = require"dataflow"

local Add = {}

function Add:Get()
  local accum = dataflow.subtermEvaluator(self.terms[1])
  for i=2, #self.terms do
    accum = accum+dataflow.subtermEvaluator(self.terms[i])
  end
  return accum
end

Add.metatable = {}

for k, v in pairs(dataflow.metatable) do
  Add.metatable[k] = v
end
Add.metatable.__index = Add

function Add.newinstance(...)
  local self = {terms = {...}}
  setmetatable(self, Add.metatable)
  return self
end

setmetatable(Add, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return Add