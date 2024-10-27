/*
 * File: computeFiniteDifferences.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

#ifndef COMPUTEFINITEDIFFERENCES_H
#define COMPUTEFINITEDIFFERENCES_H

/* Include Files */
#include "fit_SHs_types.h"
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
boolean_T computeFiniteDifferences(c_struct_T *obj,
                                   const double cEqCurrent_data[], double xk[2],
                                   double JacCeqTrans_data[]);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for computeFiniteDifferences.h
 *
 * [EOF]
 */
