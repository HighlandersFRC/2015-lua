local teleop = {}

local watchdog = WPILib.Watchdog()

teleop.Initialize = function()
    print("basicTankTeleop.Initialize")
end

teleop.Execute = function()
    watchdog:Feed()
    local leftSidePower = getJoy(1):GetY()
    local rightSidePower = getJoy(1):GetRawAxis(WPILib.asUint32(3))
    getTalon(1):Set(leftSidePower)
    getTalon(2):Set(leftSidePower)
    getTalon(3):Set(rightSidePower)
    getTalon(4):Set(rightSidePower)
    print("basicTank.Execute")
end

teleop.End = function()
    getTalon(1):Set(0)
    getTalon(2):Set(0)
    getTalon(3):Set(0)
    getTalon(4):Set(0)
    print("basicTankTeleop.End")
end

return teleop