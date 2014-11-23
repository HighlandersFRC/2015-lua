local core = require"core"

local maxHeight = 3.284
local minHeight = 0.75

local platformManual = core.getJoyBtn(2,9)
local platformZero = core.getJoyBtn(2, 10)
local driverPlatformZero = core.getJoyBtn(1, 8)

local platformPID = {
  setpoint = 0,
  accum = 0,
  last = 0,
  kP = 20,
  kI =0,
  kD = 0.1
}

local function PIDupdate(pid, val)
  local outval = 0
  outval = outval + pid.kP * (pid.setpoint - val)
  pid.accum = pid.accum + (pid.setpoint - val) * 0
  outval = outval + pid.kI * pid.accum
  outval = outval + pid.kD * (pid.last - val + pid.setpoint) * 20
  pid.last = val
  return outval
end


local platform = {
  Execute = function()
    if platformManual:Get() then
      platformPID.setpoint = -core.getJoy(2):GetRawAxis(WPILib.asUint32(2)) / 2 + 0.5
    end
    if platformZero:Get() or driverPlatformZero:Get() then
      platformPID.setpoint = 0
    end
    Robot.platform:Set(PIDupdate(platformPID, (Robot.platformPot:GetAverageVoltage()-minHeight)/(maxHeight-minHeight)))
  end
}

Robot.Teleop.Put("manual platform", platform)