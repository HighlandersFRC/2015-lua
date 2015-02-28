local returns = {
  whileHeld = function(input, cmd)
  return function()
    if input:Get() then
      Robot.CurrentScheduler:StartCommand(cmd)
    end
  end
end,

whenPressed = function (input, cmd)
  local prev = input:Get()
  return function()
    if input:Get() == true and prev == false then
      Robot.CurrentScheduler:StartCommand(cmd)
    end
    prev = input:Get()
  end
end,

whenReleased = function(input,cmd)
  local prev = input:Get()
  return function ()
    if input:Get() == false and prev == true then
      Robot.CurrentScheduler:StartCommand(cmd)
    end
    prev = input:Get()
  end
end
}
return(returns)