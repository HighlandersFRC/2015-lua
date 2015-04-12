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

local stopMotor = function(motor,subsys)

  return command{Execute = function()motor:SetCanTalonControlMode(WPILib.CanTalon.KPercentVBus) motor:Disable(); print("_____________________STOPPING STALLING MOTOR________________________________") end,subsystems = {subsys}}



end
local stalledPrint = command{ Execute = function()  print ("Count on Lifter Stall = ",countVal:Get()) end,IsFinished = function() return false end}
print("___________________________STALL TRIGGERS STARTED_______________________________________")
Robot.scheduler:AddTrigger(triggers.whenPressed(stallTrigger(robotMap.lifterUpDown,.5,1),stopMotor(robotMap.lifterUpDown,"LifterUpDown")))
--Robot.scheduler:StartCommand(stalledPrint)
