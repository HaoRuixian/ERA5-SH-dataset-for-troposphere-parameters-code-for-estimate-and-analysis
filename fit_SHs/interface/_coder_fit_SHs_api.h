/*
 * File: _coder_fit_SHs_api.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

#ifndef _CODER_FIT_SHS_API_H
#define _CODER_FIT_SHS_API_H

/* Include Files */
#include "emlrt.h"
#include "tmwtypes.h"
#include <string.h>

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void fit_SHs(real_T data[2345760], real_T ellipsoid[2410920], real_T d,
             real_T SH[65160], real_T R_SH[65160]);

void fit_SHs_api(const mxArray *const prhs[3], int32_T nlhs,
                 const mxArray *plhs[2]);

void fit_SHs_atexit(void);

void fit_SHs_initialize(void);

void fit_SHs_terminate(void);

void fit_SHs_xil_shutdown(void);

void fit_SHs_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for _coder_fit_SHs_api.h
 *
 * [EOF]
 */
