/*
 * File: xzlarf.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "xzlarf.h"
#include "rt_nonfinite.h"

/* Function Definitions */
/*
 * Arguments    : int m
 *                int n
 *                int iv0
 *                double tau
 *                double C_data[]
 *                int ic0
 *                int ldc
 *                double work[2]
 * Return Type  : void
 */
void xzlarf(int m, int n, int iv0, double tau, double C_data[], int ic0,
            int ldc, double work[2])
{
  int i;
  int ia;
  int iac;
  int lastc;
  int lastv;
  if (tau != 0.0) {
    boolean_T exitg2;
    lastv = m;
    i = iv0 + m;
    while ((lastv > 0) && (C_data[i - 2] == 0.0)) {
      lastv--;
      i--;
    }
    lastc = n;
    exitg2 = false;
    while ((!exitg2) && (lastc > 0)) {
      int exitg1;
      ia = ic0;
      do {
        exitg1 = 0;
        if (ia <= (ic0 + lastv) - 1) {
          if (C_data[ia - 1] != 0.0) {
            exitg1 = 1;
          } else {
            ia++;
          }
        } else {
          lastc = 0;
          exitg1 = 2;
        }
      } while (exitg1 == 0);
      if (exitg1 == 1) {
        exitg2 = true;
      }
    }
  } else {
    lastv = 0;
    lastc = 0;
  }
  if (lastv > 0) {
    double c;
    int b_i;
    if (lastc != 0) {
      work[0] = 0.0;
      i = 0;
      for (iac = ic0; ldc < 0 ? iac >= ic0 : iac <= ic0; iac += ldc) {
        c = 0.0;
        b_i = (iac + lastv) - 1;
        for (ia = iac; ia <= b_i; ia++) {
          c += C_data[ia - 1] * C_data[((iv0 + ia) - iac) - 1];
        }
        work[i] += c;
        i++;
      }
    }
    if (!(-tau == 0.0)) {
      i = ic0;
      for (ia = 0; ia < lastc; ia++) {
        if (work[ia] != 0.0) {
          c = work[ia] * -tau;
          b_i = lastv + i;
          for (iac = i; iac < b_i; iac++) {
            C_data[iac - 1] += C_data[((iv0 + iac) - i) - 1] * c;
          }
        }
        i += ldc;
      }
    }
  }
}

/*
 * File trailer for xzlarf.c
 *
 * [EOF]
 */
