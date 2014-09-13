local teleop = {}

teleop.drive = WPILib.RobotDrive(getTalon(1), getTalon(2), getTalon(3), getTalon(4))

teleop.Initialize = function()
    print("basicArcadeTeleop.Initialize")
end

teleop.Execute = function()
    teleop.drive:ArcadeDrive(getJoy(1))
end

teleop.End = function()
    telop.drive:ArcadeDrive(0, 0)
    print("basicArcadeTeleop.End")
end

return teleop