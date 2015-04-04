local dataflow = require"dataflow"

local Div = {}

function Div:Get()
  if self.right == nil then
    return 1 / dataflow.subtermEvaluator(self.left)
  end
  return dataflow.subtermEvaluator(self.left) / dataflow.subtermEvaluator(self.right)
end

Div.metatable = {}

for k, v in pairs(dataflow.metatable) do
  Div.metatable[k] = v
end
Div.metatable.__index = Add

function Div.newinstance(left, right)
  local self = {left = left, right = right}
  setmetatable(self, Div.metatable)
  return self
end

setmetatable(Div, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return Div