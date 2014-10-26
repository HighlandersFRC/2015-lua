#include "Joystick.h"

class JoystickAxis {
 private:
  int axisNum;
  Joystick* joy;
 public:
  JoystickAxis(Joystick* stick, int axis);
  float Get();
};
