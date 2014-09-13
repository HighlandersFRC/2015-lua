local teleop = {}

teleop.drive = WPILib.RobotDrive(getTalon(1), getTalon(2), getTalon(3), getTalon(4))

teleop.Initialize = function()
    print("basicTankTeleop.Initialize")
end

teleop.Execute = function()
    teleop.drive:TankDrive(getJoy(1), getJoy(2))
end

teleop.End = function()
    teleop.drive:TankDrive(0, 0)
    print("basicTankTeleop.End")
end

return teleop