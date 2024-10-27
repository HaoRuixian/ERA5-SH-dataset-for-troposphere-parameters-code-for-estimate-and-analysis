/*
 * File: _coder_fit_SHs_api.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "_coder_fit_SHs_api.h"
#include "_coder_fit_SHs_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;

emlrtContext emlrtContextGlobal = {
    true,                                                 /* bFirstTime */
    false,                                                /* bInitialized */
    131626U,                                              /* fVersionInfo */
    NULL,                                                 /* fErrorFunction */
    "fit_SHs",                                            /* fFunctionName */
    NULL,                                                 /* fRTCallStack */
    false,                                                /* bDebugMode */
    {2045744189U, 2170104910U, 2743257031U, 4284093946U}, /* fSigWrd */
    NULL                                                  /* fSigMem */
};

/* Function Declarations */
static real_T (
    *b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                        const emlrtMsgIdentifier *parentId))[2345760];

static real_T (*c_emlrt_marshallIn(const emlrtStack *sp,
                                   const mxArray *ellipsoid,
                                   const char_T *identifier))[2410920];

static real_T (
    *d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                        const emlrtMsgIdentifier *parentId))[2410920];

static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *d,
                                 const char_T *identifier);

static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *data,
                                 const char_T *identifier))[2345760];

static const mxArray *emlrt_marshallOut(const real_T u[65160]);

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId);

static real_T (*g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[2345760];

static real_T (*h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[2410920];

static real_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId);

/* Function Definitions */
/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T (*)[2345760]
 */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[2345760]
{
  real_T(*y)[2345760];
  y = g_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *ellipsoid
 *                const char_T *identifier
 * Return Type  : real_T (*)[2410920]
 */
static real_T (*c_emlrt_marshallIn(const emlrtStack *sp,
                                   const mxArray *ellipsoid,
                                   const char_T *identifier))[2410920]
{
  emlrtMsgIdentifier thisId;
  real_T(*y)[2410920];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(ellipsoid), &thisId);
  emlrtDestroyArray(&ellipsoid);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T (*)[2410920]
 */
static real_T (*d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[2410920]
{
  real_T(*y)[2410920];
  y = h_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *d
 *                const char_T *identifier
 * Return Type  : real_T
 */
static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *d,
                                 const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = f_emlrt_marshallIn(sp, emlrtAlias(d), &thisId);
  emlrtDestroyArray(&d);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *data
 *                const char_T *identifier
 * Return Type  : real_T (*)[2345760]
 */
static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *data,
                                 const char_T *identifier))[2345760]
{
  emlrtMsgIdentifier thisId;
  real_T(*y)[2345760];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(data), &thisId);
  emlrtDestroyArray(&data);
  return y;
}

/*
 * Arguments    : const real_T u[65160]
 * Return Type  : const mxArray *
 */
static const mxArray *emlrt_marshallOut(const real_T u[65160])
{
  static const int32_T iv[2] = {0, 0};
  static const int32_T iv1[2] = {360, 181};
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 2);
  emlrtAssign(&y, m);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T
 */
static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = i_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T (*)[2345760]
 */
static real_T (*g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[2345760]
{
  static const int32_T dims[3] = {360, 181, 36};
  real_T(*ret)[2345760];
  emlrtCheckBuiltInR2012b((emlrtCTX)sp, msgId, src, (const char_T *)"double",
                          false, 3U, (void *)&dims[0]);
  ret = (real_T(*)[2345760])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T (*)[2410920]
 */
static real_T (*h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[2410920]
{
  static const int32_T dims[3] = {360, 181, 37};
  real_T(*ret)[2410920];
  emlrtCheckBuiltInR2012b((emlrtCTX)sp, msgId, src, (const char_T *)"double",
                          false, 3U, (void *)&dims[0]);
  ret = (real_T(*)[2410920])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T
 */
static real_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId)
{
  static const int32_T dims = 0;
  real_T ret;
  emlrtCheckBuiltInR2012b((emlrtCTX)sp, msgId, src, (const char_T *)"double",
                          false, 0U, (void *)&dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const mxArray * const prhs[3]
 *                int32_T nlhs
 *                const mxArray *plhs[2]
 * Return Type  : void
 */
void fit_SHs_api(const mxArray *const prhs[3], int32_T nlhs,
                 const mxArray *plhs[2])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  real_T(*ellipsoid)[2410920];
  real_T(*data)[2345760];
  real_T(*R_SH)[65160];
  real_T(*SH)[65160];
  real_T d;
  st.tls = emlrtRootTLSGlobal;
  SH = (real_T(*)[65160])mxMalloc(sizeof(real_T[65160]));
  R_SH = (real_T(*)[65160])mxMalloc(sizeof(real_T[65160]));
  /* Marshall function inputs */
  data = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "data");
  ellipsoid = c_emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "ellipsoid");
  d = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[2]), "d");
  /* Invoke the target function */
  fit_SHs(*data, *ellipsoid, d, *SH, *R_SH);
  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*SH);
  if (nlhs > 1) {
    plhs[1] = emlrt_marshallOut(*R_SH);
  }
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void fit_SHs_atexit(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  fit_SHs_xil_terminate();
  fit_SHs_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void fit_SHs_initialize(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, NULL);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void fit_SHs_terminate(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/*
 * File trailer for _coder_fit_SHs_api.c
 *
 * [EOF]
 */
