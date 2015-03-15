local gyroOne =  WPILib.ITG3200(0)
local xCal =0
local yCal =0
local zCal =0
gyroOne:init(0x40)


local adjust = function(val)
  if  (val ~= nil) then
    if(val > 65535/2) then
      return val -65535
    else 
      return val
    end
  else
  end
end

local calibrate = function(self, points,time)
  print("Calibrating Gyro")
  --local timer = WPILib.Timer()
  print"created timer"
  --timer:Start()
  local xSum = 0
  local ySum = 0
  local zSum = 0
  local gyroVals = {}
  local numPoints = 0
  while numPoints < points do
    --if timer:Get() >= time then
      gyroVals = {gyroOne:readGyroRaw()}
      xSum = xSum +adjust(gyroVals[1])
      ySum = ySum +adjust(gyroVals[2])
      zSum = zSum +adjust(gyroVals[3])
      --timer:Reset()
      numPoints = numPoints + 1
    --end
  end
  xCal = xSum / numPoints
  yCal = ySum / numPoints
  zCal = zSum / numPoints
end

local readGyro = function()
  local x,y,z = gyroOne:readGyroRaw()
  --print((adjust(x) -xCal)/14.375,(adjust(y) -yCal)/14.375,(adjust(z) -zCal)/14.375)
  return (adjust(x) -xCal) /14.375,(adjust(y) -yCal)/14.375,(adjust(z) -zCal)/14.375
end


return {Calibrate = calibrate, Get = readGyro}