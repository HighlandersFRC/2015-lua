if ~drive then
    drive = WPILib.RobotDrive(getPWM(1), getPWM(2), getPWM(3), getPWM(4))
end

function TeleopInit()
    print("TeleopInit of tankTeleop")
end

function TeleopPeriodic()
    drive:TankDrive(getJoystick(1), getJoystick(2))
end

function TeleopDisabledInit()
    drive:TankDrive(0, 0)
    print("DisabledInit of tankTeleop")
end
