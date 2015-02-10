local core = require"core"
core.setBasicRobot()

local lanes = require"lanes"

lanes.configure()

local function lanesTest()
  local WPILib = require"WPILib"
  print"hello from lanes"
  print(WPILib.CANTalon)
end

for k, v in pairs(lanes) do print(k, v) end

local hello = lanes.gen("*", lanesTest)

hello()