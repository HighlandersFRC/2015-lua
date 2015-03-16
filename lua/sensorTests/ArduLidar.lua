local core = require"core"
core.setBasicRobot()
local arduino = io.open("/dev/ttyACM0")
local prevTime = 0
local maxMinTime = 0
local lastFragment = ""
local alpha = 0.5
local emaVal = 0
local function updateEMA(val)
  emaVal = alpha * val + (1-alpha)*emaVal
  return emaVal
end
Robot.Disabled = {
  Execute = function()
    local currentTime = WPILib.Timer.GetFPGATimestamp()
    if (prevTime + .2) < currentTime then
      local recv = arduino:read(32)
      local offset = recv:find("\n")
      local newVal = tonumber(lastFragment..recv:sub(1, offset))
      local sensorVal
      if newVal then
        sensorVal = updateEMA(newVal)
      end
      local prevOffset = offset
      offset = recv:find("\n")
      while offset ~= nil do
        --print("trying substr", recv:sub(prevOffset+1, offset), "giving", tonumber(recv:sub(prevOffset+1, offset)))
        newVal = tonumber(recv:sub(prevOffset+1, offset))
        if newVal then
          sensorVal = updateEMA(newVal)
        end
        prevOffset = offset
        offset = recv:find("\n", offset+1)
      end
      lastFragment = recv:sub(prevOffset+1, -1)
 if sensorVal then
        print(sensorVal)
      end
    end
  end
}
