/*
 * File: linearLeastSquares.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "linearLeastSquares.h"
#include "rt_nonfinite.h"
#include "xnrm2.h"
#include "xzlarf.h"
#include "xzlarfg.h"
#include <math.h>

/* Function Definitions */
/*
 * Arguments    : double lhs_data[]
 *                const int lhs_size[2]
 *                double rhs_data[]
 *                double dx[2]
 *                int m
 * Return Type  : void
 */
void linearLeastSquares(double lhs_data[], const int lhs_size[2],
                        double rhs_data[], double dx[2], int m)
{
  double jpvt[2];
  double tau_data[2];
  double vn1[2];
  double temp;
  int b_i;
  int i;
  int ii;
  int ix;
  int iy;
  int j;
  int k;
  int ma;
  int mmi;
  int nfxd;
  int temp_tmp;
  ma = lhs_size[0];
  jpvt[0] = 0.0;
  tau_data[0] = 0.0;
  jpvt[1] = 0.0;
  tau_data[1] = 0.0;
  nfxd = -1;
  for (j = 0; j < 2; j++) {
    if (jpvt[j] != 0.0) {
      nfxd++;
      if (j + 1 != nfxd + 1) {
        ix = j * ma;
        iy = nfxd * ma;
        for (k = 0; k < m; k++) {
          temp_tmp = ix + k;
          temp = lhs_data[temp_tmp];
          b_i = iy + k;
          lhs_data[temp_tmp] = lhs_data[b_i];
          lhs_data[b_i] = temp;
        }
        jpvt[j] = jpvt[nfxd];
        jpvt[nfxd] = (double)j + 1.0;
      } else {
        jpvt[j] = (double)j + 1.0;
      }
    } else {
      jpvt[j] = (double)j + 1.0;
    }
    dx[j] = 0.0;
  }
  iy = lhs_size[0];
  for (i = 0; i <= nfxd; i++) {
    ii = i * iy + i;
    mmi = m - i;
    if (i + 1 < m) {
      temp = lhs_data[ii];
      tau_data[i] = xzlarfg(mmi, &temp, lhs_data, ii + 2);
      lhs_data[ii] = temp;
    } else {
      tau_data[1] = 0.0;
    }
    if (i + 1 < 2) {
      temp = lhs_data[ii];
      lhs_data[ii] = 1.0;
      xzlarf(mmi, 1 - i, ii + 1, tau_data[0], lhs_data, (ii + iy) + 1, iy, dx);
      lhs_data[ii] = temp;
    }
  }
  if (nfxd + 1 < 2) {
    double vn2[2];
    ma = lhs_size[0];
    dx[0] = 0.0;
    vn1[0] = 0.0;
    vn2[0] = 0.0;
    dx[1] = 0.0;
    vn1[1] = 0.0;
    vn2[1] = 0.0;
    b_i = nfxd + 2;
    for (j = b_i; j < 3; j++) {
      temp = xnrm2((m - nfxd) - 1, lhs_data, (nfxd + (j - 1) * ma) + 2);
      vn1[j - 1] = temp;
      vn2[j - 1] = temp;
    }
    for (i = b_i; i < 3; i++) {
      int ip1;
      ip1 = i + 1;
      j = (i - 1) * ma;
      ii = (j + i) - 1;
      mmi = m - i;
      iy = -1;
      if ((3 - i > 1) && (fabs(vn1[1]) > fabs(vn1[i - 1]))) {
        iy = 0;
      }
      iy += i;
      if (iy + 1 != i) {
        ix = iy * ma;
        for (k = 0; k < m; k++) {
          temp_tmp = ix + k;
          temp = lhs_data[temp_tmp];
          nfxd = j + k;
          lhs_data[temp_tmp] = lhs_data[nfxd];
          lhs_data[nfxd] = temp;
        }
        temp = jpvt[iy];
        jpvt[iy] = jpvt[i - 1];
        jpvt[i - 1] = temp;
        vn1[iy] = vn1[i - 1];
        vn2[iy] = vn2[i - 1];
      }
      if (i < m) {
        temp = lhs_data[ii];
        tau_data[i - 1] = xzlarfg(mmi + 1, &temp, lhs_data, ii + 2);
        lhs_data[ii] = temp;
      } else {
        tau_data[1] = 0.0;
      }
      if (i < 2) {
        temp = lhs_data[ii];
        lhs_data[ii] = 1.0;
        xzlarf(mmi + 1, 2 - i, ii + 1, tau_data[0], lhs_data, (ii + ma) + 1, ma,
               dx);
        lhs_data[ii] = temp;
      }
      for (j = ip1; j < 3; j++) {
        iy = i + ma;
        if (vn1[1] != 0.0) {
          double temp2;
          temp = fabs(lhs_data[iy - 1]) / vn1[1];
          temp = 1.0 - temp * temp;
          if (temp < 0.0) {
            temp = 0.0;
          }
          temp2 = vn1[1] / vn2[1];
          temp2 = temp * (temp2 * temp2);
          if (temp2 <= 1.4901161193847656E-8) {
            if (i < m) {
              temp = xnrm2(mmi, lhs_data, iy + 1);
              vn1[1] = temp;
              vn2[1] = temp;
            } else {
              vn1[1] = 0.0;
              vn2[1] = 0.0;
            }
          } else {
            vn1[1] *= sqrt(temp);
          }
        }
      }
    }
  }
  iy = lhs_size[0];
  for (j = 0; j < 2; j++) {
    if (tau_data[j] != 0.0) {
      temp = rhs_data[j];
      b_i = j + 2;
      for (i = b_i; i <= iy; i++) {
        temp += lhs_data[(i + lhs_size[0] * j) - 1] * rhs_data[i - 1];
      }
      temp *= tau_data[j];
      if (temp != 0.0) {
        rhs_data[j] -= temp;
        for (i = b_i; i <= iy; i++) {
          rhs_data[i - 1] -= lhs_data[(i + lhs_size[0] * j) - 1] * temp;
        }
      }
    }
  }
  dx[0] = rhs_data[0];
  dx[1] = rhs_data[1];
  for (j = 1; j >= 0; j--) {
    iy = j + j * m;
    dx[j] /= lhs_data[iy];
    for (i = 0; i < j; i++) {
      dx[0] -= dx[j] * lhs_data[iy - 1];
    }
  }
  vn1[1] = dx[1];
  dx[(int)jpvt[0] - 1] = dx[0];
  dx[(int)jpvt[1] - 1] = vn1[1];
}

/*
 * File trailer for linearLeastSquares.c
 *
 * [EOF]
 */
