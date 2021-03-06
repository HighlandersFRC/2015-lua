%module WPILib

%include "WPILib.h"
%include "interfaces/Accelerometer.h"
%include "ADXL345_I2C.h"
%include "ADXL345_SPI.h"
%include "AnalogInput.h"
%include "AnalogOutput.h"
%include "AnalogTrigger.h"
%include "AnalogTriggerOutput.h"
%include "Buttons/InternalButton.h"
%include "Buttons/JoystickButton.h"
%include "Buttons/NetworkButton.h"
 //%include "CANJaguar.h"
 //%include "CANTalon.h"
 /*%include "Commands/Command.h"
%include "Commands/CommandGroup.h"
%include "Commands/PIDCommand.h"
%include "Commands/PIDSubsystem.h"
%include "Commands/PrintCommand.h"
%include "Commands/Scheduler.h"
%include "Commands/StartCommand.h"
%include "Commands/Subsystem.h"
%include "Commands/WaitCommand.h"
%include "Commands/WaitForChildren.h"
%include "Commands/WaitUntilCommand.h"*/
%include "Compressor.h"
%include "Counter.h"
%include "DigitalInput.h"
%include "DigitalOutput.h"
%include "DigitalSource.h"
%include "DoubleSolenoid.h"
%include "DriverStation.h"
%include "Encoder.h"
%include "ErrorBase.h"
%include "GearTooth.h"
%include "GenericHID.h"
%include "Gyro.h"
%include "I2C.h"
%include "IterativeRobot.h"
%include "InterruptableSensorBase.h"
%include "Jaguar.h"
%include "Joystick.h"
%include "MotorSafety.h"
%include "Notifier.h"
%include "PIDController.h"
%include "PIDOutput.h"
%include "PIDSource.h"
%include "Preferences.h"
%include "PWM.h"
%include "Relay.h"
%include "Resource.h"
 //%include "RobotBase.h"
%include "RobotDrive.h"
%include "SensorBase.h"
%include "SerialPort.h"
%include "Servo.h"
%include "SampleRobot.h"
%include "SmartDashboard/SendableChooser.h"
%include "SmartDashboard/SmartDashboard.h"
%include "Solenoid.h"
%include "SpeedController.h"
%include "SPI.h"
%include "Talon.h"
%include "Task.h"
 //%include "Timer.h"
%include "Ultrasonic.h"
%include "Utility.h"
%include "Victor.h"
%include "Vision/AxisCamera.h"
%include "WPIErrors.h"

%import "WPILib.h"
%import "interfaces/Accelerometer.h"
%import "ADXL345_I2C.h"
%import "ADXL345_SPI.h"
%import "AnalogInput.h"
%import "AnalogOutput.h"
%import "AnalogTrigger.h"
%import "AnalogTriggerOutput.h"
%import "Buttons/InternalButton.h"
%import "Buttons/JoystickButton.h"
%import "Buttons/NetworkButton.h"
 //%import "CANJaguar.h"
 //%import "CANTalon.h"
 /*%import "Commands/Command.h"
%import "Commands/CommandGroup.h"
%import "Commands/PIDCommand.h"
%import "Commands/PIDSubsystem.h"
%import "Commands/PrintCommand.h"
%import "Commands/Scheduler.h"
%import "Commands/StartCommand.h"
%import "Commands/Subsystem.h"
%import "Commands/WaitCommand.h"
%import "Commands/WaitForChildren.h"
%import "Commands/WaitUntilCommand.h"*/
%import "Compressor.h"
%import "Counter.h"
%import "DigitalInput.h"
%import "DigitalOutput.h"
%import "DigitalSource.h"
%import "DoubleSolenoid.h"
%import "DriverStation.h"
%import "Encoder.h"
%import "ErrorBase.h"
%import "GearTooth.h"
%import "GenericHID.h"
%import "Gyro.h"
%import "I2C.h"
%import "IterativeRobot.h"
%import "InterruptableSensorBase.h"
%import "Jaguar.h"
%import "Joystick.h"
%import "Notifier.h"
%import "PIDController.h"
%import "PIDOutput.h"
%import "PIDSource.h"
%import "Preferences.h"
%import "PWM.h"
%import "Relay.h"
%import "Resource.h"
 //%import "RobotBase.h"
%import "RobotDrive.h"
%import "SensorBase.h"
%import "SerialPort.h"
%import "Servo.h"
%import "SampleRobot.h"
%import "SmartDashboard/SendableChooser.h"
%import "SmartDashboard/SmartDashboard.h"
%import "Solenoid.h"
%import "SpeedController.h"
%import "SPI.h"
%import "Talon.h"
%import "Task.h"
 //%import "Timer.h"
%import "Ultrasonic.h"
%import "Utility.h"
%import "Victor.h"
%import "Vision/AxisCamera.h"
%import "WPIErrors.h"

uint32_t asUint32(float);
float fromUint32(uint32_t);

std::string* asStdString(const char *);
const char* fromStdString(std::string *);

%{
#include "WPILib.h"
#include "CounterBase.h"
#include "I2C.h"
#include <math.h>
  	typedef CounterBase::EncodingType EncodingType;
  	typedef PIDSource::PIDSourceParameter PIDSourceParameter;
	typedef I2C::Port Port;

  	uint32_t asUint32(float arg) {
    		return uint32_t(arg);
  	}
	
	float fromUint32(uint32_t arg) {
		return float(arg);
	}

  	std::string* asStdString(const char * arg) {
  		return new std::string(arg);
  	}

  	const char * fromStdString(std::string * arg) {
  		return arg->c_str();
  	}
%}
