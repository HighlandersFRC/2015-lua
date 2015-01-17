local currentState = 1
local currentEnabled = false

local core = require"core"

if DEBUG_ENABLE then
  require("mobdebug").start(DEBUG_SERVER_ADDRESS, DEBUG_SERVER_PORT)
end

print"start of main.lua"

local stateNames = {"Disabled", "Autonomous", "Teleop"}

local function NoOp() end

(Robot.Disabled.Initialize or NoOp)()

while true do
  local newState
  if IsDisabled() then
    newState = 1
  end
  if IsAutonomous() and IsEnabled() then
    newState = 2
  end
  if IsOperatorControl() and IsEnabled() then
    newState = 3
  end
  
  if currentState ~= newState then
    local endfn = Robot[stateNames[currentState]].End or NoOp
    endfn(stateNames[currentState])
    local initfn = Robot[stateNames[newState]].Initialize or NoOp
    initfn(stateNames[currentState])
    currentState = newState
  end
  
  local exec = Robot[stateNames[newState]].Execute or NoOp
  exec(stateNames[newState])
  core.notify_keepAlive()
end
