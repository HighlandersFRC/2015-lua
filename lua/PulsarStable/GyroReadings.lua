--WPILib.I2C.Port.kOnboard
print("Running GyroReadings Startup")
local count = 0
local gyroOne =  WPILib.ITG3200(0)
local accelerometer = WPILib.ADXL345_I2C(0)
local xCal =0
local yCal =0
local zCal =0
print("Started Test Startup")
local core = require"core"
--local time = 0
require("mqtt_lua_console").start()
core.setCompositeRobot()
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
local calibrate = function(points,time)
  local timer = WPILib.Timer()
  timer:Start()
  local xSum = 0
  local ySum = 0
  local zSum = 0
  local gyroVals = {}
  local numPoints = 0
  while numPoints < points do
    if timer:Get() >= time then
      gyroVals = {gyroOne:readGyroRaw()}
      xSum = xSum +adjust(gyroVals[1])
      ySum = ySum +adjust(gyroVals[2])
      zSum = zSum +adjust(gyroVals[3])
      timer:Reset()
      numPoints = numPoints + 1
    end
  end
  return (xSum / numPoints), (ySum / numPoints) , (zSum /numPoints)
end
Robot.Teleop.Put("Testing_Gyros",{
    Initialize = function()
      gyroOne:init(0x40)
      -- gyroOne:zeroCalibrate(10,1)

      xCal,yCal,zCal = calibrate(100,.01)
      print("Calculated Calibration : ".. xCal .."   "..yCal.."   "..zCal)
      print("Calibration Complete")
      print"GyroInit"
    end,
    Execute = function()

      if count % 500 == 0 then 
        local x,y,z = gyroOne:readGyroRaw()
        print((adjust(x) -xCal).."   "..(adjust(y) -yCal).."   "..(adjust(z) -zCal))

        --print(accelerometer:GetX().."    "..accelerometer:GetY().. "    "..accelerometer:GetZ())
      end
      count = count + 1
    end,
    End = function()

    end
  })
print("I am done with Testing Startup")







