local core = require"core"
core.setBasicRobot()
local arduino = io.open("/dev/ttyACM0")
local prevTime = 0
local lastFragment = ""

Robot.Disabled = {
  Execute = function()
    if prevTime + 0.05 < WPILib.Timer.GetFPGATimestamp() then
      local recv = arduino:read(32)
      local offset = recv:find("\n")
      local sensorVal = tonumber(lastFragment..recv:sub(1, offset))
      local prevOffset = offset
      offset = recv:find("\n")
      while offset ~= nil do
        --print("trying substr", recv:sub(prevOffset+1, offset), "giving", tonumber(recv:sub(prevOffset+1, offset)))
        sensorVal = tonumber(recv:sub(prevOffset+1, offset)) or sensorVal
        prevOffset = offset
        offset = recv:find("\n", offset+1)
      end
      lastFragment = recv:sub(prevOffset+1, -1)
      print(sensorVal)
    end
  end
}
