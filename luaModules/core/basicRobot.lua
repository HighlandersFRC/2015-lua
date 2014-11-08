local function createBasicRobot()
    local RobotStart = {}
    RobotStart.reset = createBasicRobot
    RobotStart.type = "basic"
    RobotStart.Autonomous = {}
    RobotStart.Teleop = {}
    RobotStart.Disabled = {}
    return RobotStart
end

return function() Robot = createBasicRobot() end