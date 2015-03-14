local core = require"core"
core.setBasicRobot()
local arduino = io.open("/dev/ttyACM0")
local prevTime = 0
local maxMinTime = 0
local lastFragment = ""
local min = nil
Robot.Disabled = {
  Execute = function()
    local currentTime = WPILib.Timer.GetFPGATimestamp()
    if (prevTime + .2) < currentTime then
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
      if min == nil then
        min = tonumber(sensorVal)
        max = tonumber(sensorVal)
      end
      print(sensorVal)
      prevTime = WPILib.Timer.GetFPGATimestamp()
      if tonumber(sensorVal) > max then
        max = tonumber(sensorVal)
      end
      if tonumber(sensorVal) < min then
        min = tonumber(sensorVal)
      end
      if (maxMinTime + 5) < currentTime then
        print("min >>>", min,"              max >>>", max)
        maxMinTime = WPILib.Timer.GetFPGATimestamp()
       min = nil
      end
    end
  end
}
