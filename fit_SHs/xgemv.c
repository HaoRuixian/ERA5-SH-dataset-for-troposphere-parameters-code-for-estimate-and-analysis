/*
 * File: xgemv.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "xgemv.h"
#include "rt_nonfinite.h"

/* Function Definitions */
/*
 * Arguments    : int m
 *                const double A_data[]
 *                int lda
 *                const double x_data[]
 *                double y[2]
 * Return Type  : void
 */
void xgemv(int m, const double A_data[], int lda, const double x_data[],
           double y[2])
{
  int ia;
  int iac;
  if (m != 0) {
    int i;
    int iy;
    y[0] = 0.0;
    y[1] = 0.0;
    iy = 0;
    i = lda + 1;
    for (iac = 1; lda < 0 ? iac >= i : iac <= i; iac += lda) {
      double c;
      int i1;
      c = 0.0;
      i1 = (iac + m) - 1;
      for (ia = iac; ia <= i1; ia++) {
        c += A_data[ia - 1] * x_data[ia - iac];
      }
      y[iy] += c;
      iy++;
    }
  }
}

/*
 * File trailer for xgemv.c
 *
 * [EOF]
 */
