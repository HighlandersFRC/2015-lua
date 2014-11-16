local intakeOutBtn = getJoyBtn(2, 4)
local intakeInBtn = getJoyBtn(2, 5)
local intakeWheelInBtn = getJoyBtn(2, 3)
local intakeWheelOutBtn = getJoyBtn(2, 2)

local intakeOut = {
  Execute = function()
    if intakeOutBtn:Get() then
      Robot.intakeArmIn:Set(false)
      Robot.intakeArmOut:Set(true)
    end
  end
}

local intakeIn = {
  Execute = function()
    if intakeInBtn:Get() then
      Robot.intakeArmIn:Set(true)
      Robot.intakeArmOut:Set(false)
    end
  end
}

local intakeWheels = {
  Execute = function()
    if intakeWheelInBtn:Get() then
      intakeWheel:Set(-1)
    end
    if intakeWheelOutBtn:Get() then
      intakeWheel:Set(1)
    end
  end
}

Robot.Teleop.Put("intake out", intakeOut)
Robot.Teleop.Put("intake in", intakeIn)
Robot.Teleop.Put("intake wheels", intakeWheels)