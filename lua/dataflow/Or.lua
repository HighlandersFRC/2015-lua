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

Or.metatable = {__index = Or}

function Or.newinstance(...)
  local self = {terms = {...}}
  setmetatable(self, Or.metatable)
  return self
end

setmetatable(Or, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return Or