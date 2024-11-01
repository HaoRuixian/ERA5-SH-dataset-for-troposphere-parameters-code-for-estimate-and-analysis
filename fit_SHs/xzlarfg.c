/*
 * File: xzlarfg.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "xzlarfg.h"
#include "rt_nonfinite.h"
#include "xnrm2.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Declarations */
static double rt_hypotd_snf(double u0, double u1);

/* Function Definitions */
/*
 * Arguments    : double u0
 *                double u1
 * Return Type  : double
 */
static double rt_hypotd_snf(double u0, double u1)
{
  double a;
  double y;
  a = fabs(u0);
  y = fabs(u1);
  if (a < y) {
    a /= y;
    y *= sqrt(a * a + 1.0);
  } else if (a > y) {
    y /= a;
    y = a * sqrt(y * y + 1.0);
  } else if (!rtIsNaN(y)) {
    y = a * 1.4142135623730951;
  }
  return y;
}

/*
 * Arguments    : int n
 *                double *alpha1
 *                double x_data[]
 *                int ix0
 * Return Type  : double
 */
double xzlarfg(int n, double *alpha1, double x_data[], int ix0)
{
  double tau;
  double xnorm;
  int k;
  tau = 0.0;
  xnorm = xnrm2(n - 1, x_data, ix0);
  if (xnorm != 0.0) {
    double beta1;
    beta1 = rt_hypotd_snf(*alpha1, xnorm);
    if (*alpha1 >= 0.0) {
      beta1 = -beta1;
    }
    if (fabs(beta1) < 1.0020841800044864E-292) {
      int i;
      int knt;
      knt = 0;
      i = (ix0 + n) - 2;
      do {
        knt++;
        for (k = ix0; k <= i; k++) {
          x_data[k - 1] *= 9.9792015476736E+291;
        }
        beta1 *= 9.9792015476736E+291;
        *alpha1 *= 9.9792015476736E+291;
      } while ((fabs(beta1) < 1.0020841800044864E-292) && (knt < 20));
      beta1 = rt_hypotd_snf(*alpha1, xnrm2(n - 1, x_data, ix0));
      if (*alpha1 >= 0.0) {
        beta1 = -beta1;
      }
      tau = (beta1 - *alpha1) / beta1;
      xnorm = 1.0 / (*alpha1 - beta1);
      for (k = ix0; k <= i; k++) {
        x_data[k - 1] *= xnorm;
      }
      for (k = 0; k < knt; k++) {
        beta1 *= 1.0020841800044864E-292;
      }
      *alpha1 = beta1;
    } else {
      int i;
      tau = (beta1 - *alpha1) / beta1;
      xnorm = 1.0 / (*alpha1 - beta1);
      i = (ix0 + n) - 2;
      for (k = ix0; k <= i; k++) {
        x_data[k - 1] *= xnorm;
      }
      *alpha1 = beta1;
    }
  }
  return tau;
}

/*
 * File trailer for xzlarfg.c
 *
 * [EOF]
 */
