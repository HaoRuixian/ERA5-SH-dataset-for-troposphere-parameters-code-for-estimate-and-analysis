/*
 * File: checkStoppingCriteria.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

#ifndef CHECKSTOPPINGCRITERIA_H
#define CHECKSTOPPINGCRITERIA_H

/* Include Files */
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
int checkStoppingCriteria(const double gradf[2], double relFactor,
                          double funDiff, const double x[2], const double dx[2],
                          int funcCount, boolean_T stepSuccessful, int *iter);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for checkStoppingCriteria.h
 *
 * [EOF]
 */
