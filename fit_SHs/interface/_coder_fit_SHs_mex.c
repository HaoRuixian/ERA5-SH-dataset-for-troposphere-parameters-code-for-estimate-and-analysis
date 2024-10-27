/*
 * File: _coder_fit_SHs_mex.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "_coder_fit_SHs_mex.h"
#include "_coder_fit_SHs_api.h"

/* Function Definitions */
/*
 * Arguments    : int32_T nlhs
 *                mxArray *plhs[]
 *                int32_T nrhs
 *                const mxArray *prhs[]
 * Return Type  : void
 */
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&fit_SHs_atexit);
  /* Module initialization. */
  fit_SHs_initialize();
  /* Dispatch the entry-point. */
  unsafe_fit_SHs_mexFunction(nlhs, plhs, nrhs, prhs);
  /* Module termination. */
  fit_SHs_terminate();
}

/*
 * Arguments    : void
 * Return Type  : emlrtCTX
 */
emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
                           NULL, (const char_T *)"GBK", true);
  return emlrtRootTLSGlobal;
}

/*
 * Arguments    : int32_T nlhs
 *                mxArray *plhs[2]
 *                int32_T nrhs
 *                const mxArray *prhs[3]
 * Return Type  : void
 */
void unsafe_fit_SHs_mexFunction(int32_T nlhs, mxArray *plhs[2], int32_T nrhs,
                                const mxArray *prhs[3])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *outputs[2];
  int32_T b_nlhs;
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 3, 4,
                        7, "fit_SHs");
  }
  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 7,
                        "fit_SHs");
  }
  /* Call the function. */
  fit_SHs_api(prhs, nlhs, outputs);
  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }
  emlrtReturnArrays(b_nlhs, &plhs[0], &outputs[0]);
}

/*
 * File trailer for _coder_fit_SHs_mex.c
 *
 * [EOF]
 */
