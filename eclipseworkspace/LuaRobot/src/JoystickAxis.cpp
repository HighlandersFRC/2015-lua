#include "JoystickAxis.h"

JoystickAxis::JoystickAxis(Joystick* stick, int axis): joy(stick), axisNum(axis){}

float JoystickAxis::Get() {
  return joy->GetRawAxis(axisNum);
}
