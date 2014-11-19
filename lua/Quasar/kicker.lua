local core = require"core"

local kickerManual = core.getJoyBtn(2,8)


local kick = {
  Execute = function()
    if kickerManual:Get() then
      local power = core.getJoy(2):GetRawAxis(WPILib.asUint32(4))
      Robot.kickA:Set(power)
      Robot.kickB:Set(power)
     
    else 
      Robot.kickA:Set(0)
      Robot.kickB:Set(0)
    end
    
  end
}

Robot.Teleop.Put("manual kick", kick)