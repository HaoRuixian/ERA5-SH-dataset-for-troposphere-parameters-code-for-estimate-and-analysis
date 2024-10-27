/*
 * File: driver.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

#ifndef DRIVER_H
#define DRIVER_H

/* Include Files */
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void driver(const double fun_workspace_x_data[], int fun_workspace_x_size,
            const double fun_workspace_y_data[], int fun_workspace_y_size,
            double x0[2], double *resnorm, double fCurrent_data[],
            int *fCurrent_size, double *exitflag, double *output_iterations,
            double *output_funcCount, double *output_stepsize,
            double *output_firstorderopt, char output_algorithm[19],
            double lambda_lower[2], double lambda_upper[2],
            double jacobian_data[], int jacobian_size[2]);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for driver.h
 *
 * [EOF]
 */
