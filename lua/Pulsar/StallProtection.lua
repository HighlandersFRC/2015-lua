local dataflow = require"dataflow"
local Accum = require"dataflow.Accumulator"
local Not = require"dataflow.Not"
local And = require"dataflow.And"
local Abs = require"dataflow.Abs"
local triggers = require"triggers"
local command = require"command"
local compare = require"dataflow.Compare"


local function outputVoltage(motor)
  return dataflow.wrap(function() return motor:GetOutputVoltage() end)
end

local function outputCurrent(motor)
  return dataflow.wrap(function() return motor:GetOutputCurrent() end)
end

local function busVoltage(motor)
  return dataflow.wrap(function() return motor:GetBusVoltage() end)
end

local inspect = function(name,src)
return dataflow.wrap(function()
      local source = dataflow.subtermEvaluator(src)
      print(name, source)
      return source
    end
  )

end
local stallTrigger = function(motor,threshold,motorStallRatio)
  print("CheckingStall")
  local current = Abs(outputCurrent(motor)*(busVoltage(motor)/outputVoltage(motor)))
  --current = inspect("current",current)
  local count = Accum(And(Not(compare(outputVoltage(motor),"==",0)),compare( Abs(current/outputVoltage(motor)/motorStallRatio),">",threshold)), 0, 6)
  --count = inspect("count",count)
  return compare(count,">",5)   
end
local countVal = stallTrigger(robotMap.lifterUpDown,.5,1)

stallTrigger = function(motor, maxCurrent)
  --I apologise for the variable names.
  local prevVel = 0 --last measured velocity
  local prevPrevVel = 0 --velocity before the last measured velocity
  local prevVelTime = WPILib.Timer.GetFPGATimestamp() --time of the last velocity measurement
  local prevPrevVelTime = WPILib.Timer.GetFPGATimestamp() --time of the measurement before the last velocity measurement
  local accel = 0
  local prevCurrent = 0 --last measured current (Amps)
  local prevPrevCurrent = 0 --current before the last measured current
  local prevCurrentTime = WPILib.Timer.GetFPGATimestamp() --time of the last current measurement
  local prevPrevCurrentTime = WPILib.Timer.GetFPGATimestamp() --time of the measurement before the last current measurement
  local dcurrent = 0
  local function getSpeed()
    local currVel = motor:GetSpeed()
    local currTime = WPILib.Timer.GetFPGATimestamp()
    if currVel ~= prevVel then
      prevPrevVel = prevVel
      prevPrevVelTime = prevVelTime
      prevVel = currVel
      prevVelTime = currTime
    end
    local deltaTime = currTime - prevPrevVelTime
    accel = (currVel - prevPrevVel)/deltaTime
    return currVel, accel
  end
  local function getCurrent()
    local outputVoltage = motor:GetOutputVoltage()
    local current
    if outputVoltage ~= 0 then
      current = motor:GetOutputCurrent() * motor:GetBusVoltage() / outputVoltage
    else
      current = 0
    end
    local currTime = WPILib.Timer.GetFPGATimestamp()
    if current ~= prevCurrent then
      prevPrevCurrent = prevCurrent
      prevPrevCurrentTime = prevCurrentTime
      prevCurrent = current
      prevCurrentTime = currTime
    end
    local deltaTime = currTime - prevPrevCurrentTime
    dcurrent = (current - prevPrevCurrent)/deltaTime
    return current, dcurrent
  end
  return {
    Get = function()
      local speed, accel = getSpeed()
      local current, dcurrent = getCurrent()
      local stall = false
      if OI.lifterUpDownDisable:Get() then 
        return false
        end
      if math.abs(current) > maxCurrent then
        if speed >= 0 and current < 0 and accel <= 0 and dcurrent < 0 then
          stall = true
        elseif speed <= 0 and current > 0 and accel >= 0 and dcurrent > 0 then
          stall = true
        else
          stall = false
        end
      else
        stall = false
      end
     -- print("speed "..speed.." acceleration "..tostring(accel).." current "..tostring(current).." dI/dt "..tostring(dcurrent).." stall "..tostring(stall))
      return stall
    end
  }
end

local stopMotor = function(motor,subsys)

  return command{
    Execute = function() motor:SetControlMode(WPILib.CANTalon.kPercentVbus) motor:Set(0); print("_____________________STOPPING STALLING MOTOR________________________________") end,
    IsFinished = function() return false end,
    Interrupted = function() print"_______STOP STALLED MOTOR INTERRUPTED_____" end,
    subsystems = {subsys}}
end
local stalledPrint = command{ Execute = function()  print ("Count on Lifter Stall = ",countVal:Get()) end,IsFinished = function() return false end}
print("___________________________STALL TRIGGERS STARTED_______________________________________")
--Robot.scheduler:AddTrigger(triggers.whenPressed(stallTrigger(robotMap.lifterUpDown,.5,1),stopMotor(robotMap.lifterUpDown,"LifterUpDown")))
Robot.scheduler:AddTrigger(triggers.whenPressed(stallTrigger(robotMap.lifterUpDown, 100),stopMotor(robotMap.lifterUpDown,"LifterUpDown")))
--Robot.scheduler:StartCommand(stalledPrint)
