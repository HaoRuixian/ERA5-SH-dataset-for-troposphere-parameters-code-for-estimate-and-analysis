/*
 * File: nullAssignment.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "nullAssignment.h"
#include "rt_nonfinite.h"

/* Function Definitions */
/*
 * Arguments    : double x_data[]
 *                int *x_size
 *                const boolean_T idx_data[]
 *                int idx_size
 * Return Type  : void
 */
void nullAssignment(double x_data[], int *x_size, const boolean_T idx_data[],
                    int idx_size)
{
  int k;
  int k0;
  int nxout;
  nxout = 0;
  for (k = 0; k < idx_size; k++) {
    nxout += idx_data[k];
  }
  nxout = *x_size - nxout;
  k0 = -1;
  for (k = 0; k < *x_size; k++) {
    if ((k + 1 > idx_size) || (!idx_data[k])) {
      k0++;
      x_data[k0] = x_data[k];
    }
  }
  if (nxout < 1) {
    *x_size = 0;
  } else {
    *x_size = nxout;
  }
}

/*
 * File trailer for nullAssignment.c
 *
 * [EOF]
 */
