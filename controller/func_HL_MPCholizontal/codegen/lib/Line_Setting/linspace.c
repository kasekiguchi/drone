/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: linspace.c
 *
 * MATLAB Coder version            : 5.0
 * C/C++ source code generated on  : 04-Nov-2020 16:27:23
 */

/* Include Files */
#include "linspace.h"
#include "Line_Setting.h"
#include <math.h>

/* Function Definitions */

/*
 * Arguments    : double d1
 *                double d2
 *                double y[10]
 * Return Type  : void
 */
void linspace(double d1, double d2, double y[10])
{
  int k;
  double delta1;
  double delta2;
  y[9] = d2;
  y[0] = d1;
  if (d1 == -d2) {
    for (k = 0; k < 8; k++) {
      y[k + 1] = d2 * ((2.0 * ((double)k + 2.0) - 11.0) / 9.0);
    }
  } else if (((d1 < 0.0) != (d2 < 0.0)) && ((fabs(d1) > 8.9884656743115785E+307)
              || (fabs(d2) > 8.9884656743115785E+307))) {
    delta1 = d1 / 9.0;
    delta2 = d2 / 9.0;
    for (k = 0; k < 8; k++) {
      y[k + 1] = (d1 + delta2 * ((double)k + 1.0)) - delta1 * ((double)k + 1.0);
    }
  } else {
    delta1 = (d2 - d1) / 9.0;
    for (k = 0; k < 8; k++) {
      y[k + 1] = d1 + ((double)k + 1.0) * delta1;
    }
  }
}

/*
 * File trailer for linspace.c
 *
 * [EOF]
 */
