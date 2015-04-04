local dataflow = require"dataflow"

local compare = {}

function compare:Get()
  if self.operator == ">" then
    return dataflow.subtermEvaluator(self.left) > dataflow.subtermEvaluator(self.right)
  end
  if self.operator == ">=" then
    return dataflow.subtermEvaluator(self.left) >= dataflow.subtermEvaluator(self.right)
  end
  if self.operator == "<" then
    return dataflow.subtermEvaluator(self.left) < dataflow.subtermEvaluator(self.right)
  end
  if self.operator == "<=" then
    return dataflow.subtermEvaluator(self.left) <= dataflow.subtermEvaluator(self.right)
  end
  if self.operator == "==" then
    return dataflow.subtermEvaluator(self.left) == dataflow.subtermEvaluator(self.right)
  end
end

compare.metatable = {}
for k, v in pairs(dataflow.metatable) do
  compare.metatable[k] = v
end
compare.metatable.__index = compare

function compare.newinstance(left, operator, right)
  local self = {left = left, operator = operator, right = right}
  setmetatable(self, compare.metatable)
  return self
end

setmetatable(compare, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return compare