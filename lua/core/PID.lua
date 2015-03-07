
local function PIDupdate(pid, val)
  local err = pid.setpoint -  val
  if pid.continuous then
    if math.abs(err) > (pid.maxInput - pid.minInput)/2 then
      if err > 0 then
        err = err - pid.maxInput + pid.minInput
      else
        err = err + pid.maxInput -pid.minInput
      end
    end
  end
  if not pid.kI == 0 then
    local potentialIGain = (pid.accum + err)*pid.kI
    if potentialIGain < pid.maxOutput then
      if potentialIGain > pid.minOutput then
        pid.accum = pid.accum + err
      else
        pid.accum = pid.minOutput / pid.kI
      end
    else
      pid.accum = pid.maxOutput/pid.kI 
    end
  end
  local result = pid.kP * err + pid.kI * pid.accum + pid.kD *(err - pid.previousErr) + pid.setpoint * pid.kF
  pid.previousErr = err
  if result > pid.maxOutput then
    result = pid.maxOutput

  elseif result < pid.minOutput then
    result = pid.minOutput
  end
  return result
--[[
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
    ]]
end
local PIDenable = function(self)


  self.lastTime = WPILib.Timer.GetFPGATimestamp()
end

local createPID = function(KP,KI,KD,KF) 
  PID = {
    setpoint = 0,
    accum = 0,
    previousErr = 0,
    last = 0,
    kP = KP,
    kI = KI,
    kD = KD,
    kF = KF or 0,
    lastTime = WPILib.Timer.GetFPGATimestamp(),
    Update = PIDupdate,
    Enable = PIDenable,
    maxOutput =1,
    minOutput =-1 ,
    maxInput =0,
    minInput  =0,
    continuous = false
  }
  return PID
end

  return createPID