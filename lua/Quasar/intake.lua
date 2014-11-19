local core = require"core"

local intakeOutBtn = core.getJoyBtn(2, 4)
local intakeInBtn = core.getJoyBtn(2, 5)
local intakeWheelInBtn = core.getJoyBtn(2, 3)
local intakeWheelOutBtn = core.getJoyBtn(2, 2)

local intakeInOut = {
  Execute = function()
    if intakeOutBtn:Get() then
      Robot.intakeArmIn:Set(false)
      Robot.intakeArmOut:Set(true)
    end
    if intakeInBtn:Get() then
      Robot.intakeArmIn:Set(true)
      Robot.intakeArmOut:Set(false)
    end
  end
}

local intakeWheels = {
  Execute = function()
    if intakeWheelInBtn:Get() then
      Robot.intakeWheel:Set(1)
    elseif intakeWheelOutBtn:Get() then
      Robot.intakeWheel:Set(-1)
    else
      Robot.intakeWheel:Set(0)
    end
  end
}

Robot.Teleop.Put("intake in out", intakeInOut)
Robot.Teleop.Put("intake wheels", intakeWheels)