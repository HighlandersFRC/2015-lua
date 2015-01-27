
local function PIDupdate(pid, val)
  local outval = 0
  outval = outval + pid.kP * (pid.setpoint - val)
  pid.accum = pid.accum + (pid.setpoint - val)
  outval = outval + pid.kI * pid.accum
  outval = outval + pid.kD * (pid.last - val)
  pid.last = val
  return outval
end


local createPID = function(KP,KI,KD) 
  PID = {
  setpoint = 0,
  accum = 0,
  last = 0,
  kP = KP,
  kI = KI,
  kD = KD,
  Update = PIDupdate
}
return PID
end

return createPID