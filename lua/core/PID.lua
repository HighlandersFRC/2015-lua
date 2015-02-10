
local function PIDupdate(pid, val)
  local outval = 0
  local deltaTime = WPILib.Timer.GetFPGATimestamp() - pid.lastTime
  outval = outval + pid.kP * (pid.setpoint - val)
  pid.accum = pid.accum + (pid.setpoint - val) * deltaTime
  outval = outval + pid.kI * pid.accum
  outval = outval + pid.kD/deltaTime * (pid.last - val) 
  pid.last = val 
  pid.lastTime = WPILib.Timer.GetFPGATimestamp()
  return outval
end
local PIDenable = function()
  
  
  PID.lastTime = WPILib.Timer.GetFPGATimestamp()
  end

local createPID = function(KP,KI,KD) 
  PID = {
  setpoint = 0,
  accum = 0,
  last = 0,
  kP = KP,
  kI = KI,
  kD = KD,
  lastTime = WPILib.Timer.GetFPGATimestamp(),
  Update = PIDupdate,
  enable = PIDenable
}
return PID
end

return createPID