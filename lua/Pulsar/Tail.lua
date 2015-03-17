local core = require"core"
local tailPower = 0.5
local triggers = require"triggers"

local tailMove = {
  Initialize = function()
    print("Started moving")
  end,
  Execute = function()
    if(OI.tail:GetPOV()==0) then
      print("Going up")
      robotMap.tail:Set(tailPower)
    elseif OI.tail:GetPOV()==180 then
      print("going Down")
      robotMap.tail:Set(-tailPower)
    else
      robotMap.tail:Set(0)
    end
  end,
  IsFinished = function() 
    return false
  end,
  End = function(self)
    print("Ending")
    robotMap.tail:Set(0)
  end,
  Interrupted = function(self)
    self:End()
  end,
  subsystems = {
    "Tail"
  },
}

--local tailTrigger = function()
--  if not (OI.tail:GetPOV()==-1) then
--    print("starting command")
--    Robot.CurrentScheduler:StartCommand(tailMove)
--  end
--end


--Robot.scheduler:AddTrigger(tailTrigger)
Robot.scheduler:StartCommand(tailMove)
checkWPILib"after debugPrint"