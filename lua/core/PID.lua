
local function PIDupdate(pid, val)
  print"in PIDupdate"
  local outval = 0
  print"set outval"
  print("lastTime", pid.lastTime)
  print("WPILib", WPILib)
  print("WPILib.Timer", WPILib.Timer)
  print("WPILib.Timer.GetFPGATimestamp", WPILib.Timer.GetFPGATimestamp)
  print("metatable", getmetatable(WPILib.Timer))
  local deltaTime = WPILib_backup.Timer.GetFPGATimestamp() - pid.lastTime
  print"set deltaTime"
  outval = outval + pid.kP * (pid.setpoint - val)
  pid.accum = pid.accum + (pid.setpoint - val) * deltaTime
  outval = outval + pid.kI * pid.accum
  outval = outval + pid.kD/deltaTime * (pid.last - val) 
  pid.last = val 
  pid.lastTime = WPILib.Timer.GetFPGATimestamp()
  return outval
end
local PIDenable = function(self)


  self.lastTime = WPILib.Timer.GetFPGATimestamp()
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
    Enable = PIDenable
  }
  return PID
end

return createPID