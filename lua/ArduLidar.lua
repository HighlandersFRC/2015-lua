local core = require"core"
local arduino = io.open"/dev/ttyACM0"

local lidar = {}
local lastFragment = ""
lidar.alpha = 0.5
lidar.emaVal = 0
local function updateEMA(val)
  lidar.emaVal = lidar.alpha * val + (1-lidar.alpha)*lidar.emaVal
end

function lidar:Get()
  return self.emaVal
end

core.register_keepAlive(
  coroutine.create(
    function()
      while true do
        local recv = arduino:read(32)
        local offset = recv:find("\n")
        local newVal = tonumber(lastFragment..recv:sub(1, offset))
        if newVal then
          updateEMA(newVal)
        end
        local prevOffset = offset
        offset = recv:find("\n")
        while offset ~= nil do
          --print("trying substr", recv:sub(prevOffset+1, offset), "giving", tonumber(recv:sub(prevOffset+1, offset)))
          newVal = tonumber(recv:sub(prevOffset+1, offset))
          if newVal then
            updateEMA(newVal)
          end
          prevOffset = offset
          offset = recv:find("\n", offset+1)
        end
        lastFragment = recv:sub(prevOffset+1, -1)
        coroutine.yield()
      end
    end
  ))

return lidar