setCompositeRobot()

local motors = {getTalon(1), getTalon(2), getTalon(3), getTalon(4)}

local leftDrive = {
    Initialize = function() end,

    Execute = function()
        local pwr = getJoy(1):GetY()
        motors[1]:Set(pwr)
	motors[2]:Set(pwr)
    end,

    End = function()
        motors[1]:Set(0)
	motors[2]:Set(0)
    end
}

local rightDrive = {
    Initialize = function() end,

    Execute = function()
        local pwr = getJoy(2):GetY()
        motors[3]:Set(pwr)
	motors[4]:Set(pwr)
    end,

    End = function()
        motors[1]:Set(0)
	motors[2]:Set(0)
    end
}

Robot.Teleop.Put("leftDrive", leftDrive)
Robot.Teleop.Put("rightDrive", rightDrive)