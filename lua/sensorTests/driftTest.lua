local core = require"core"
local port = WPILib.SerialPort(57600,1)
local lastTime
local timer
local drift
local displacement
core.setBasicRobot()
local navX = WPILib.AHRS(port,50)
Robot.Disabled = {
  Initialize = function()
    while navX:GetYaw() == 0 do end
    timer = WPILib.Timer()
    timer:Start()
    lastTime = 0
    drift = navX:GetYaw()
  end,
  Execute = function()
    if timer:Get() - lastTime > 1 then
      print(navX:GetYaw(), displacement)
      lastTime = timer:Get()
    end
    displacement = math.abs(drift - navX:GetYaw())
  end
  
}
