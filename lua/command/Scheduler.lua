local Scheduler = {}

Scheduler.Execute = function(sched)
  debugPrint("begginning of scheduler.execute ")
  local currSchedBackup = Robot.CurrentScheduler
  Robot.CurrentScheduler = sched
  debugPrint("started triggers")
  for _, trig in ipairs(sched.triggers) do
    trig()
  end
  debugPrint("ended triggers")
  local commands = sched.commands
  local index = 1
  debugPrint("number of current Commands :", #commands)
  while index <= #commands do
    local command = sched.commands[index]
    debugPrint("handling Command ", command)
    if command.Execute then
      command:Execute()
      
    end
    if command.IsFinished and command:IsFinished() then
      table.remove(sched.commands, index)
      sched:UnlockCommand(command)
      if command.End then
        command:End()
      end
      sched:StartDefaults(command.subsystems)
    else
      index = index + 1
    end
  end
  Robot.CurrentScheduler = currSchedBackup
end

Scheduler.AddTrigger = function(sched, trig)

  table.insert(sched.triggers, trig)
end

Scheduler.StartCommand = function(sched, command)
  debugPrint("started start command")
  if not command then debug.debug() end
  local currSchedBackup = Robot.CurrentScheduler
  Robot.CurrentScheduler = sched
  local canStart = true
  for _, subsys in ipairs(command.subsystems) do
    if sched.lockSubsys[subsys] then
      if sched.lockSubsys[subsys].IsInteruptible then
        if not sched.lockSubsys[subsys]:IsInterruptible() then
          canStart = false
        end
      end
    end
  end
  if canStart then
    for _, subsys in ipairs(command.subsystems) do
      if sched.lockSubsys[subsys] then
        sched:CancelCommand(sched.lockSubsys[subsys])
      end
      sched.lockSubsys[subsys] = command
    end
    table.insert(sched.commands, command)
    command:Initialize()
    Robot.CurrentScheduler = currSchedBackup
    return true
  end
  Robot.CurrentScheduler = currSchedBackup
  return false
end

Scheduler.CancelCommand = function(sched, command)
  local currSchedBackup = Robot.CurrentScheduler
  Robot.CurrentScheduler = sched
  local i = 1
  while i <= #sched.commands do
    if sched.commands[i] == command then
      sched.commands[i]:Interrupted()
      sched:UnlockCommand(sched.commands[i])
      table.remove(sched.commands, i)
    else
      i = i + 1
    end
  end
  Robot.CurrentScheduler = currSchedBackup
end

Scheduler.UnlockCommand = function(sched, command)
  for _, subsys in ipairs(command.subsystems) do
    sched.lockSubsys[subsys] = nil
  end
end

Scheduler.SetDefaultCommand = function(sched, subsystem, command)
  sched.defaultCommands[subsystem] = command
  if not sched.lockSubsys[subsystem] then
    sched:StartCommand(command)
  end
end

Scheduler.CancelBySubsystem = function(sched, subsystem)
  sched:CancelCommand(sched.lockSubsys[subsystem])
end

Scheduler.CancelAll = function(sched)
  local currSchedBackup = Robot.CurrentScheduler
  Robot.CurrentScheduler = sched
  while #sched.commands ~= 0 do
    sched.commands[1]:Interrupted()
    for subsys in sched.commands[1].subsystems do
      sched.lockSubsys[subsys] = nil
    end
    table.remove(sched.commands, 1)
  end
  Robot.CurrentScheduler = currSchedBackup
end

Scheduler.StartDefaults = function(sched, subsystems)
  if subsystems then
    for _, subsys in ipairs(subsystems) do
      if sched.defaultCommands[subsys] then
        if not sched.lockSubsys[subsys] then
          print("Starting default command for "..subsys)
          sched:StartCommand(sched.defaultCommands[subsys])
        end
      end
    end
  else
    for subsys, command in pairs(sched.defaultCommands) do
      if not sched.lockSubsys[subsys] then
        sched:StartCommand(command)
      end
    end
  end
end

Scheduler.metatable = {
  __index = Scheduler
}

Scheduler.newinstance = function()
  local newSched = {
    commands = {},
    lockSubsys = {},
    defaultCommands = {},
    triggers = {}
  }
  setmetatable(newSched, Scheduler.metatable)
  return newSched
end

setmetatable(Scheduler, {
    __call = function(class, ...) return class.newinstance(...) end
  })

return Scheduler
