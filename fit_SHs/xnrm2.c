/*
 * File: xnrm2.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "xnrm2.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Definitions */
/*
 * Arguments    : int n
 *                const double x_data[]
 *                int ix0
 * Return Type  : double
 */
double xnrm2(int n, const double x_data[], int ix0)
{
  double y;
  int k;
  y = 0.0;
  if (n >= 1) {
    if (n == 1) {
      y = fabs(x_data[ix0 - 1]);
    } else {
      double scale;
      int kend;
      scale = 3.3121686421112381E-170;
      kend = (ix0 + n) - 1;
      for (k = ix0; k <= kend; k++) {
        double absxk;
        absxk = fabs(x_data[k - 1]);
        if (absxk > scale) {
          double t;
          t = scale / absxk;
          y = y * t * t + 1.0;
          scale = absxk;
        } else {
          double t;
          t = absxk / scale;
          y += t * t;
        }
      }
      y = scale * sqrt(y);
    }
  }
  return y;
}

/*
 * File trailer for xnrm2.c
 *
 * [EOF]
 */
