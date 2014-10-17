local teleop = {}

local watchdog = WPILib.Watchdog()

teleop.Initialize = function()
    print("basicTankTeleop.Initialize")
end

teleop.Execute = function()
    watchdog:Feed()
    local leftSidePower = -getJoy(1):GetY()
    local rightSidePower = getJoy(2):GetY()
    getTalon(1):Set(rightSidePower)
    getTalon(2):Set(rightSidePower)
    getTalon(3):Set(leftSidePower)
    getTalon(4):Set(leftSidePower)
    --print("basicTank.Execute")
end

teleop.End = function()
    getTalon(1):Set(0)
    getTalon(2):Set(0)
    getTalon(3):Set(0)
    getTalon(4):Set(0)
    print("basicTankTeleop.End")
end

return teleop