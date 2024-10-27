/*
 * File: fit_SHs.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

#ifndef FIT_SHS_H
#define FIT_SHS_H

/* Include Files */
#include "fit_SHs_types.h"
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void b_fit_SHs_anonFcn2(const double x_data[], int x_size,
                        const double y_data[], int y_size,
                        const double params[2], double varargout_1_data[],
                        int *varargout_1_size);

void c_binary_expand_op(c_struct_T *in1, const double in2[2]);

extern void fit_SHs(const double data[2345760], const double ellipsoid[2410920],
                    double d, double SH[65160], double R_SH[65160]);

void fit_SHs_anonFcn2(const double x_data[], int x_size, const double y_data[],
                      int y_size, const double params[2],
                      double varargout_1_data[], int *varargout_1_size);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for fit_SHs.h
 *
 * [EOF]
 */
