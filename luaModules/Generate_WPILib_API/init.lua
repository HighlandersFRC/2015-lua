local serpent = dofile"/lua/serpent/init.lua"

local function typeAPI(t)
  if type(t) == "table" then
    return "class"
  end
  if type(t) == "function" then
    return "function"
  end
  return "value"
end

local function populateAPI(t)
  local api = {}
  for k, v in pairs(t) do
    local APItype = typeAPI(v)
    print("handling node", k, "of type", APItype)
    api[k] = {
      type = typeAPI(v),
      description = "",
      returns = ""
    }
    if APItype == "class" or APItype == "lib" then
      api[k].childs = populateAPI(v)
    end
  end
  return api  
end

print"beginning generation"

local WPILibAPI = populateAPI(WPILib)

print"finished generation"

local outputfile = io.open("/lua/Generate_WPILib_API/output.lua", "w")

print"beginning serialization"

outputfile:write(
  serpent.dump(
    {
      WPILib = {
        type = "lib",
        description = "The WPI library for FRC Robotics",
        childs = WPILibAPI
      }
    }
  )
 )

outputfile:close()

print"finished serialization"