local group = {}

function group.subsysUnion(...) 
  local temp = {}
  local args, n = {...}, select("#", ...)
  for a=1, n do
    for i=1, #args[a].subsystems do
      temp[args[a].subsystems[i]]=true
    end
  end
  local result = {}
  for k, v in pairs(temp) do
    table.insert(result, k)
  end
  return result
end

function group.subsysConflicts(...)
  local temp = {}
  local args, n = {...}, select("#", ...)
  for a=1, n do
    for i=1, #args[a].subsystems do
      if temp[args[a].subsystems[i] then
        return true
      end
      temp[args[a].subsystems[i]]=true
    end
  end
  return false
end

return group