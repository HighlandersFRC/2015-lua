-- This code sets up core functions and data for the Lua Robot.
-- It must never be ran more than once per run.
-- It is run automatically on boot.
-- It should usually not be modified.

print("beginning lua core initialization")

local joysticks = {}

function getJoy(id)
    if joysticks[id] then
        return joysticks[id]
    end
    joysticks[id] = WPILib.Joystick(WPILib.asUint32(id))
    return joysticks[id]
end

local joystickButtons = {}

function getJoyBtn(joy, btn)
    if not joystickButtons[joy] then
        joystickButtons[joy] = {}
    end
    if joystickButtons[joy][btn] then
        return joystickButtons[joy][btn]
    end
    joystickButtons[joy][btn] = WPILib.JoystickButton(getJoy(joy), btn)
    return joystickButtons[joy][btn]
end

local talons = {}

function getTalon(id)
    if talons[id] then
        return talons[id]
    end
    talons[id] = WPILib.Talon(WPILib.asUint32(id))
    return talons[id]
end

local AINs = {}

function getAIN(id)
    if AINs[id] then
        return AINs[id]
    end
    AINs[id] = WPILib.AnalogChannel(WPILib.asUint32(id))
    return PWMs[id]
end

local DIOs = {}

function getDIO(id)
    if DIOs[id] then
        return DIOs[id]
    end
    DIOs[id] = WPILib.DigitalChannel(WPILib.asUint32(id))
    return DIOs[id]
end

local solenoids = {}

function getSolenoid(id)
    if solenoids[id] then
        return solenoids[id]
    end
    solenoids[id] = WPILib.Solenoid(WPILib.asUint32(id))
    return solenoids[id]
end

setCompositeRobot = dofile("/lua/core/compositeRobot.lua")

setBasicRobot = dofile("/lua/core/basicRobot.lua")

coAction = dofile("/lua/core/coroutineAction.lua")

seqAction = dofile("/lua/core/sequentialAction.lua")

parAction = dofile("/lua/core/parallelAction.lua")

serialize = dofile("/lua/core/serialize.lua")

print("finished lua core initialization")
