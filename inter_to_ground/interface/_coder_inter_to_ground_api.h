/*
 * File: _coder_inter_to_ground_api.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 10-Apr-2024 16:52:13
 */

#ifndef _CODER_INTER_TO_GROUND_API_H
#define _CODER_INTER_TO_GROUND_API_H

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
void inter_to_ground(real_T ellipsoid[57862080], real_T temK[57862080],
                     real_T rh[57862080], real_T sh[57862080], real32_T pre[37],
                     real_T geoid_ground[1563840], real_T b_time,
                     real_T pressure[57862080]);

void inter_to_ground_api(const mxArray *const prhs[7], int32_T nlhs,
                         const mxArray *plhs[4]);

void inter_to_ground_atexit(void);

void inter_to_ground_initialize(void);

void inter_to_ground_terminate(void);

void inter_to_ground_xil_shutdown(void);

void inter_to_ground_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for _coder_inter_to_ground_api.h
 *
 * [EOF]
 */
