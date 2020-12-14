/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: Line_Setting.c
 *
 * MATLAB Coder version            : 5.0
 * C/C++ source code generated on  : 04-Nov-2020 16:27:23
 */

/* Include Files */
#include "Line_Setting.h"
#include "linspace.h"

/* Function Definitions */

/*
 * 経路を作るためのセクションポイントの再設計
 * 軌道を直角にしないための処理
 * Arguments    : double Sectionnumber
 *                const double Sectionpoint_data[]
 *                const int Sectionpoint_size[2]
 *                double bfjudge
 *                double S_limit
 *                double p_return[38]
 * Return Type  : void
 */
void Line_Setting(double Sectionnumber, const double Sectionpoint_data[], const
                  int Sectionpoint_size[2], double bfjudge, double S_limit,
                  double p_return[38])
{
  double sn;
  double d;
  int x1_tmp;
  int i;
  double x1[10];
  double d1;
  int y1_tmp;
  double b_y1[10];
  double x2[10];
  double y2[10];
  if (bfjudge == 1.0) {
    sn = Sectionnumber - 1.0;
    if (Sectionnumber - 1.0 < 1.0) {
      sn = 1.0;
    }
  } else {
    sn = Sectionnumber;
    if (Sectionnumber + 2.0 > S_limit) {
      sn = Sectionnumber - 1.0;
    }
  }

  d = Sectionpoint_data[(int)(sn + 1.0) - 1];
  if (d == Sectionpoint_data[(int)(sn + 2.0) - 1]) {
    x1_tmp = (int)sn - 1;
    linspace(Sectionpoint_data[x1_tmp], d - 0.1, x1);
    y1_tmp = (int)sn;
    sn = Sectionpoint_data[y1_tmp + Sectionpoint_size[0]];
    linspace(Sectionpoint_data[x1_tmp + Sectionpoint_size[0]], sn, b_y1);
    linspace(Sectionpoint_data[y1_tmp] - 0.1, Sectionpoint_data[2], x2);
    linspace(sn, Sectionpoint_data[Sectionpoint_size[0] + 2], y2);
  } else {
    x1_tmp = (int)sn;
    i = x1_tmp - 1;
    d1 = Sectionpoint_data[i];
    if (d1 == d) {
      linspace(d1 - 0.1, Sectionpoint_data[x1_tmp], x1);
      sn = Sectionpoint_data[x1_tmp + Sectionpoint_size[0]] - 0.1;
      linspace(Sectionpoint_data[i + Sectionpoint_size[0]], sn, b_y1);
      linspace(Sectionpoint_data[x1_tmp], Sectionpoint_data[2], x2);
      linspace(sn, Sectionpoint_data[Sectionpoint_size[0] + 2], y2);
    } else {
      sn = Sectionpoint_data[x1_tmp];
      linspace(d1, sn, x1);
      y1_tmp = x1_tmp + Sectionpoint_size[0];
      linspace(Sectionpoint_data[i + Sectionpoint_size[0]],
               Sectionpoint_data[y1_tmp], b_y1);
      linspace(sn, Sectionpoint_data[2], x2);
      linspace(Sectionpoint_data[y1_tmp], Sectionpoint_data[Sectionpoint_size[0]
               + 2], y2);
    }
  }

  for (x1_tmp = 0; x1_tmp < 10; x1_tmp++) {
    p_return[x1_tmp << 1] = x1[x1_tmp];
  }

  for (x1_tmp = 0; x1_tmp < 9; x1_tmp++) {
    p_return[(x1_tmp + 10) << 1] = x2[x1_tmp + 1];
  }

  for (x1_tmp = 0; x1_tmp < 10; x1_tmp++) {
    p_return[(x1_tmp << 1) + 1] = b_y1[x1_tmp];
  }

  for (x1_tmp = 0; x1_tmp < 9; x1_tmp++) {
    p_return[((x1_tmp + 10) << 1) + 1] = y2[x1_tmp + 1];
  }

  /*  Line_struct = pchip([x1 x2(2:end)],[y1 y2(2:end)]); */
}

/*
 * File trailer for Line_Setting.c
 *
 * [EOF]
 */
