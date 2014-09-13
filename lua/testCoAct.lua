setBasicRobot()

local teleop = {}

teleop.drive = WPILib.RobotDrive(getTalon(1), getTalon(2), getTalon(3), getTalon(4))

local function teleopDrive()
    while true do
        print("starting coroutine drive")
        coroutine.yield()
	print("coroutine drive")
	teleop.drive:ArcadeDrive(getJoy(1))
    end
end

local coact = coAction(teleopDrive)

teleop.Initialize = function()
    print("teleopInit")
    coact:Initialize()
    print("end teleopInit")
end

teleop.Execute = function()
    print("Execute")
    coact:Execute()
    print("end Execute")
end

teleop.End = function()
    coact:End()
end

Robot.Teleop = teleop