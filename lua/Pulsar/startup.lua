local count = 0

require"core"
--require("mqtt_lua_console").start()

Robot = {
  Autonomous = {
    Initialize = function()
      print"AutonomousInit"
    end,
    End = function()
      print"AutonomousEnd"
    end
  },
  Teleop = {
    Initialize = function()
      print"TeleopInit"
    end,
    Execute = function()
      Robot.drive:MecanumDrive_Cartesian(Robot.joy:GetRawAxis(2), Robot.joy:GetRawAxis(0), Robot.joy:GetRawAxis(1))
      --Robot.drive:TankDrive(Robot.joy:GetRawAxis(1), Robot.joy:GetRawAxis(3))
      if count % 50 == 0 then
        print("BLTalon voltage: "..tostring(Robot.BLTalon:GetOutputVoltage()).." current: "..tostring(Robot.BLTalon:GetOutputCurrent()))
      end
      count = count + 1
    end,
    End = function()
      Robot.drive:MecanumDrive_Cartesian(0, 0, 0)
    end
  },
  Disabled = {
    Initialize = function()
      print"DisabledInit"
    end,
    End = function()
      print"DisabledEnd"
    end
  },
  joy = WPILib.Joystick(0),
  FLTalon = WPILib.CANTalon(1),
  BLTalon = WPILib.CANTalon(2),
  FRTalon = WPILib.CANTalon(3),
  BRTalon = WPILib.CANTalon(4)
}

Robot.drive = WPILib.RobotDrive(Robot.BLTalon, Robot.FLTalon, Robot.FRTalon, Robot.BRTalon)

Robot.drive:SetSafetyEnabled(false)

Robot.drive:SetInvertedMotor(0, true)
Robot.drive:SetInvertedMotor(1, true)
Robot.drive:SetInvertedMotor(2, true)
Robot.drive:SetInvertedMotor(3, true)