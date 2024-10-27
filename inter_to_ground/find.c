/*
 * File: find.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 10-Apr-2024 16:52:13
 */

/* Include Files */
#include "find.h"
#include "rt_nonfinite.h"

/* Function Definitions */
/*
 * Arguments    : const boolean_T x[36]
 *                int i_data[]
 *                int *i_size
 * Return Type  : void
 */
void eml_find(const boolean_T x[36], int i_data[], int *i_size)
{
  int idx;
  int ii;
  boolean_T exitg1;
  idx = 0;
  ii = 0;
  exitg1 = false;
  while ((!exitg1) && (ii < 36)) {
    if (x[ii]) {
      idx++;
      i_data[idx - 1] = ii + 1;
      if (idx >= 36) {
        exitg1 = true;
      } else {
        ii++;
      }
    } else {
      ii++;
    }
  }
  if (idx < 1) {
    *i_size = 0;
  } else {
    *i_size = idx;
  }
}

/*
 * File trailer for find.c
 *
 * [EOF]
 */
