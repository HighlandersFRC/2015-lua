#include "TwoMotorPIDoutput.h"

void TwoMotorPIDoutput::PIDWrite(float output) {
  sc1->Set(output);
  sc2->Set(output);
}
