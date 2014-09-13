if ~drive then
    drive = WPILib.RobotDrive(getPWM(1), getPWM(2), getPWM(3), getPWM(4))
end

function TeleopInit()
    print("TeleopInit of arcadeTeleop")
end

function TeleopPeriodic()
    drive:ArcadeDrive(getJoystick(1))
end

function TeleopDisabledInit()
    drive:ArcadeDrive(0, 0)
    print("DisabledInit of arcadeTeleop")
end