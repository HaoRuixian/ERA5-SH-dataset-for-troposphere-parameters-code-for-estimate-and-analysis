/*
 * File: interp1.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 10-Apr-2024 16:52:13
 */

/* Include Files */
#include "interp1.h"
#include "rt_nonfinite.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Definitions */
/*
 * Arguments    : const double varargin_1[37]
 *                const double varargin_2[37]
 *                double varargin_3
 * Return Type  : double
 */
double interp1(const double varargin_1[37], const double varargin_2[37],
               double varargin_3)
{
  double x[37];
  double y[37];
  double Vq;
  int low_i;
  memcpy(&y[0], &varargin_2[0], 37U * sizeof(double));
  memcpy(&x[0], &varargin_1[0], 37U * sizeof(double));
  low_i = 0;
  int exitg1;
  do {
    exitg1 = 0;
    if (low_i < 37) {
      if (rtIsNaN(varargin_1[low_i])) {
        exitg1 = 1;
      } else {
        low_i++;
      }
    } else {
      double xtmp;
      if (varargin_1[1] < varargin_1[0]) {
        for (low_i = 0; low_i < 18; low_i++) {
          xtmp = x[low_i];
          x[low_i] = x[36 - low_i];
          x[36 - low_i] = xtmp;
          xtmp = y[low_i];
          y[low_i] = y[36 - low_i];
          y[36 - low_i] = xtmp;
        }
      }
      if (rtIsNaN(varargin_3)) {
        Vq = rtNaN;
      } else if (varargin_3 > x[36]) {
        Vq = y[36] + (varargin_3 - x[36]) / (x[36] - x[35]) * (y[36] - y[35]);
      } else if (varargin_3 < x[0]) {
        Vq = y[0] + (varargin_3 - x[0]) / (x[1] - x[0]) * (y[1] - y[0]);
      } else {
        int high_i;
        int low_ip1;
        low_i = 1;
        low_ip1 = 2;
        high_i = 37;
        while (high_i > low_ip1) {
          int mid_i;
          mid_i = (low_i + high_i) >> 1;
          if (varargin_3 >= x[mid_i - 1]) {
            low_i = mid_i;
            low_ip1 = mid_i + 1;
          } else {
            high_i = mid_i;
          }
        }
        xtmp = x[low_i - 1];
        xtmp = (varargin_3 - xtmp) / (x[low_i] - xtmp);
        if (xtmp == 0.0) {
          Vq = y[low_i - 1];
        } else if (xtmp == 1.0) {
          Vq = y[low_i];
        } else if (y[low_i - 1] == y[low_i]) {
          Vq = y[low_i - 1];
        } else {
          Vq = (1.0 - xtmp) * y[low_i - 1] + xtmp * y[low_i];
        }
      }
      exitg1 = 1;
    }
  } while (exitg1 == 0);
  return Vq;
}

/*
 * File trailer for interp1.c
 *
 * [EOF]
 */
