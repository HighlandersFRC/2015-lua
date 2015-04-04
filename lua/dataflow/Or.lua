local dataflow = require"dataflow"

local Or = {}

function Or:Get()
  local temp
  for i=1, #self.terms do
    temp = dataflow.subtermEvaluator(self.terms[i])
    if temp then
      return temp
    end
  end
  return temp
end

Or.metatable = {}

for k, v in pairs(dataflow.metatable) do
  Or.metatable[k] = v
end
Or.metatable.__index = Add

function Or.newinstance(...)
  local self = {terms = {...}}
  setmetatable(self, Or.metatable)
  return self
end

setmetatable(Or, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return Or