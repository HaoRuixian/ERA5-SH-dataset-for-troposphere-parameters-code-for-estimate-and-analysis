/*
 * File: unsafeSxfun.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "unsafeSxfun.h"
#include "rt_nonfinite.h"

/* Function Definitions */
/*
 * Arguments    : double in1_data[]
 *                int *in1_size
 *                const double in3_data[]
 *                const int *in3_size
 *                const double in4[2]
 * Return Type  : void
 */
void binary_expand_op(double in1_data[], int *in1_size, const double in3_data[],
                      const int *in3_size, const double in4[2])
{
  double b_in3_data[36];
  double b_in4;
  int b_in3_size;
  int i;
  int stride_0_0;
  int stride_1_0;
  b_in4 = in4[0];
  if (*in1_size == 1) {
    b_in3_size = *in3_size;
  } else {
    b_in3_size = *in1_size;
  }
  stride_0_0 = (*in3_size != 1);
  stride_1_0 = (*in1_size != 1);
  if (*in1_size == 1) {
    *in1_size = *in3_size;
  }
  for (i = 0; i < *in1_size; i++) {
    b_in3_data[i] = in3_data[i * stride_0_0] - b_in4 * in1_data[i * stride_1_0];
  }
  *in1_size = b_in3_size;
  for (i = 0; i < b_in3_size; i++) {
    b_in4 = b_in3_data[i];
    in1_data[i] = b_in4 * b_in4;
  }
}

/*
 * File trailer for unsafeSxfun.c
 *
 * [EOF]
 */
