local core = require"core"

local triggers = require"triggers"
local encoderInOut = 0
local encoderUpDown = 0
local countInOut = 0
local  encoderInOutCheck = {
  Initialize = function()
    encoderInOut = robotMap.lifterInOut:GetEncPosition()
    countInOut = 0
    end,
    Execute = function
    if WPILib.PowerDistributionPanel.GetCurrent(9) >= (.5 * WPILib.PowerDistributionPanel.GetVoltage(9) / 12) then
      if encoderInOut == robotMap.lifterInOut:GetEncPosition() then
        countInOut = countInOut+1
        if countInOut > 100 then
          robotMap.lifterInOut:Set(0)
          Subsystems.lifterInOutPID = false
        end
      else
        if countInOut > 0 then
          countInOut = countInOut -1
        end
      end
      encoderInOut = robotMap.lifterInOut:GetEncPosition()
    end,
    IsFinished = function() 
    return false
    end,
    End = function(self)
      return false
    end,
    Interrupted = function(self)
      self:End()
    end,
    subsystems = {

    },
  }

--robotMap.LifterUpDown:GetOutputCurrent()