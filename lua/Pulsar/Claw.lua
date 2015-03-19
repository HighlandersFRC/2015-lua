local core = require"core"
local clawPower = 0.5
local triggers = require"triggers"
local tailPosition = require"Pulsar.TailPosition"
local lifterPoint = require"Pulsar.lifterPoint"
local function degrees2ticks(degrees)
  return degrees /360*1440
end

local function ticks2Degrees(ticks)
  return ticks /1440*360
end
local tailMove = {
  Initialize = function()
  end,
  Execute = function()
    if(OI.tail:GetPOV()==180) then
     -- print("going down")
      robotMap.claw:Set(clawPower)
      robotMap.clawTwo:Set(-clawPower)

    elseif OI.tail:GetPOV()==0 then
   --   print("going up")
      robotMap.claw:Set(-clawPower)
      robotMap.clawTwo:Set(clawPower)

    elseif OI.tail:GetPOV()==270 then
 --print("going left")
      robotMap.tail:Set(1)

    elseif OI.tail:GetPOV()==90 then
 --print("going right")
      robotMap.tail:Set(-1)

else
  robotMap.claw:SetVoltageRampRate(0)
    robotMap.clawTwo:SetVoltageRampRate(0)
      robotMap.clawTwo:Set(0)
      robotMap.claw:Set(0)
      robotMap.tail:Set(0)
    end
  end,
  IsFinished = function() 
    return false
  end,
  End = function(self)
    print("Ending")
    robotMap.claw:Set(0)
    robotMap.tail:Set(0)
    robotMap.clawTwo:Set(0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "claw"
  },
}
Robot.scheduler:AddTrigger(triggers.whenPressed({Get = function() return OI.tail:GetPOV()> -1 end},tailMove))

--Robot.scheduler:AddTrigger(tailTrigger)
Robot.scheduler:StartCommand(tailMove)
checkWPILib"after debugPrint"