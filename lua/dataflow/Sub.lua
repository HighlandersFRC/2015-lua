local dataflow = require"dataflow"

local Sub = {}

function Sub:Get()
  if self.right == nil then
    return - dataflow.subtermEvaluator(self.left)
  end
  return dataflow.subtermEvaluator(self.left) - dataflow.subtermEvaluator(self.right)
end

Sub.metatable = {__index = Sub}

function Sub.newinstance(left, right)
  local self = {left = left, right = right}
  setmetatable(self, Sub.metatable)
  return self
end

setmetatable(Sub, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return Sub