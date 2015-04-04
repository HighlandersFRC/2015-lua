local dataflow = require"dataflow"

local And = {}

function And:Get()
  local temp
  for i=1, #self.terms do
    temp = dataflow.subtermEvaluator(self.terms[i])
    if not temp then
      return temp
    end
  end
  return temp
end

And.metatable = {}

for k, v in pairs(dataflow.metatable) do
  And.metatable[k] = v
end
And.metatable.__index = Add

function And.newinstance(...)
  local self = {terms = {...}}
  setmetatable(self, And.metatable)
  return self
end

setmetatable(And, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return And