#include "WPILib.h"

class TwoMotorPIDoutput : PIDOutput {
 public:
  virtual void PIDWrite(float output);
 TwoMotorPIDoutput(Talon *s1, Talon *s2): sc1(s1), sc2(s2) {}
 private:
  Talon* sc1;
  Talon* sc2;
};
