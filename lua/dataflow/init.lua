local modname = ...

local Compare, Add, Sub, Mul, Div, And, Or

local dataflow = {}

local flowObjectMT

local function wrap(source)
  if type(source) == "function" then
    source = {Get=source}
  else
    source = {Get=function() return source:Get() end}
  end
  setmetatable(source, flowObjectMT)
  return source
end

flowObjectMT = {
  __gt = function(a, b)
    return Compare(a, ">" b)
  end,
  __lt = function(a, b)
    return Compare(a, "<", b)
  end,
  __eq = function(a, b)
    return Compare(a, "==", b)
  end,
  __le = function(a, b)
    return Compare(a, "<=", b)
  end,
  __ge = function(a, b)
    return Compare(a, ">=", b)
  end,
  __add = function(a, b)
    return Add(a, b)
  end,
  __sub = function(a, b)
    return Sub(a, b)
  end,
  __mul = function(a, b)
    return Mul(a, b)
  end,
  __div = function(a, b)
    return Div(a, b)
  end
}

function dataflow.subtermEvaluator(val)
  if type(val) == "number" then
    return val
  end
  if type(val) == "boolean" then
    return val
  end
  if type(val) == "table" then
    return val:Get()
  end
  if type(val) == "function" then
    return val()
  end
  if type(val) == "thread" then
    return coroutine.resume(val)
  end
  if type(val) == "userdata" then
    return val:Get()
  end
end

dataflow.wrap = wrap
dataflow.metatable = flowObjectMT

package.loaded[modname] = dataflow

Compare = require"dataflow.Compare"
Add = require"dataflow.Add"
Sub = require"dataflow.Sub"
Mul = require"dataflow.Mul"
Div = require"dataflow.Div"