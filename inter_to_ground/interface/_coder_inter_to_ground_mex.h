/*
 * File: _coder_inter_to_ground_mex.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 10-Apr-2024 16:52:13
 */

#ifndef _CODER_INTER_TO_GROUND_MEX_H
#define _CODER_INTER_TO_GROUND_MEX_H

/* Include Files */
#include "emlrt.h"
#include "mex.h"
#include "tmwtypes.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
MEXFUNCTION_LINKAGE void mexFunction(int32_T nlhs, mxArray *plhs[],
                                     int32_T nrhs, const mxArray *prhs[]);

emlrtCTX mexFunctionCreateRootTLS(void);

void unsafe_inter_to_ground_mexFunction(int32_T nlhs, mxArray *plhs[4],
                                        int32_T nrhs, const mxArray *prhs[7]);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for _coder_inter_to_ground_mex.h
 *
 * [EOF]
 */
