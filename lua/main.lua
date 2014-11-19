local currentState = 1
local currentEnabled = false

if DEBUG_ENABLE then
  require("mobdebug").start(DEBUG_SERVER_ADDRESS, DEBUG_SERVER_PORT)
end

print"start of main.lua"

local watchdog = WPILib.Watchdog()

local stateNames = {"Disabled", "Autonomous", "Teleop"}

local function NoOp() end

(Robot.Disabled.Initialize or NoOp)()

--serialize.tree(WPILib.Watchdog)
--WPILib.SmartDashboard.init()
--WPILib.SmartDashboard.PutNumber(WPILib.asStdString("test"), 42)

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
  --notify_keepAlive()
  watchdog:Feed()
end
