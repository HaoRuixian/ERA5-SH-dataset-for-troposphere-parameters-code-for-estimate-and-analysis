/*
 * File: _coder_inter_to_ground_api.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 10-Apr-2024 16:52:13
 */

/* Include Files */
#include "_coder_inter_to_ground_api.h"
#include "_coder_inter_to_ground_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;

emlrtContext emlrtContextGlobal = {
    true,                                                 /* bFirstTime */
    false,                                                /* bInitialized */
    131626U,                                              /* fVersionInfo */
    NULL,                                                 /* fErrorFunction */
    "inter_to_ground",                                    /* fFunctionName */
    NULL,                                                 /* fRTCallStack */
    false,                                                /* bDebugMode */
    {2045744189U, 2170104910U, 2743257031U, 4284093946U}, /* fSigWrd */
    NULL                                                  /* fSigMem */
};

static const int32_T iv[4] = {360, 181, 37, 24};

/* Function Declarations */
static real_T (
    *b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                        const emlrtMsgIdentifier *parentId))[57862080];

static void b_emlrt_marshallOut(const real_T u[57862080], const mxArray *y);

static real32_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *pre,
                                     const char_T *identifier))[37];

static real32_T (*d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                     const emlrtMsgIdentifier *parentId))[37];

static real_T (*e_emlrt_marshallIn(const emlrtStack *sp,
                                   const mxArray *geoid_ground,
                                   const char_T *identifier))[1563840];

static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *ellipsoid,
                                 const char_T *identifier))[57862080];

static const mxArray *emlrt_marshallOut(const real_T u[57862080]);

static real_T (
    *f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                        const emlrtMsgIdentifier *parentId))[1563840];

static real_T g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *b_time,
                                 const char_T *identifier);

static real_T h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId);

static real_T (*i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[57862080];

static real32_T (*j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                     const emlrtMsgIdentifier *msgId))[37];

static real_T (*k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[1563840];

static real_T l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId);

/* Function Definitions */
/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T (*)[57862080]
 */
static real_T (
    *b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                        const emlrtMsgIdentifier *parentId))[57862080]
{
  real_T(*y)[57862080];
  y = i_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const real_T u[57862080]
 *                const mxArray *y
 * Return Type  : void
 */
static void b_emlrt_marshallOut(const real_T u[57862080], const mxArray *y)
{
  emlrtMxSetData((mxArray *)y, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)y, &iv[0], 4);
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *pre
 *                const char_T *identifier
 * Return Type  : real32_T (*)[37]
 */
static real32_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *pre,
                                     const char_T *identifier))[37]
{
  emlrtMsgIdentifier thisId;
  real32_T(*y)[37];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(pre), &thisId);
  emlrtDestroyArray(&pre);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real32_T (*)[37]
 */
static real32_T (*d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                     const emlrtMsgIdentifier *parentId))[37]
{
  real32_T(*y)[37];
  y = j_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *geoid_ground
 *                const char_T *identifier
 * Return Type  : real_T (*)[1563840]
 */
static real_T (*e_emlrt_marshallIn(const emlrtStack *sp,
                                   const mxArray *geoid_ground,
                                   const char_T *identifier))[1563840]
{
  emlrtMsgIdentifier thisId;
  real_T(*y)[1563840];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = f_emlrt_marshallIn(sp, emlrtAlias(geoid_ground), &thisId);
  emlrtDestroyArray(&geoid_ground);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *ellipsoid
 *                const char_T *identifier
 * Return Type  : real_T (*)[57862080]
 */
static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *ellipsoid,
                                 const char_T *identifier))[57862080]
{
  emlrtMsgIdentifier thisId;
  real_T(*y)[57862080];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(ellipsoid), &thisId);
  emlrtDestroyArray(&ellipsoid);
  return y;
}

/*
 * Arguments    : const real_T u[57862080]
 * Return Type  : const mxArray *
 */
static const mxArray *emlrt_marshallOut(const real_T u[57862080])
{
  static const int32_T b_iv[4] = {0, 0, 0, 0};
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(4, (const void *)&b_iv[0], mxDOUBLE_CLASS,
                              mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv[0], 4);
  emlrtAssign(&y, m);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T (*)[1563840]
 */
static real_T (*f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[1563840]
{
  real_T(*y)[1563840];
  y = k_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *b_time
 *                const char_T *identifier
 * Return Type  : real_T
 */
static real_T g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *b_time,
                                 const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = h_emlrt_marshallIn(sp, emlrtAlias(b_time), &thisId);
  emlrtDestroyArray(&b_time);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T
 */
static real_T h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = l_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T (*)[57862080]
 */
static real_T (*i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[57862080]
{
  real_T(*ret)[57862080];
  emlrtCheckBuiltInR2012b((emlrtCTX)sp, msgId, src, (const char_T *)"double",
                          false, 4U, (void *)&iv[0]);
  ret = (real_T(*)[57862080])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real32_T (*)[37]
 */
static real32_T (*j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                     const emlrtMsgIdentifier *msgId))[37]
{
  static const int32_T dims = 37;
  real32_T(*ret)[37];
  emlrtCheckBuiltInR2012b((emlrtCTX)sp, msgId, src, (const char_T *)"single",
                          false, 1U, (void *)&dims);
  ret = (real32_T(*)[37])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T (*)[1563840]
 */
static real_T (*k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[1563840]
{
  static const int32_T dims[3] = {360, 181, 24};
  real_T(*ret)[1563840];
  emlrtCheckBuiltInR2012b((emlrtCTX)sp, msgId, src, (const char_T *)"double",
                          false, 3U, (void *)&dims[0]);
  ret = (real_T(*)[1563840])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T
 */
static real_T l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
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
 * Arguments    : const mxArray * const prhs[7]
 *                int32_T nlhs
 *                const mxArray *plhs[4]
 * Return Type  : void
 */
void inter_to_ground_api(const mxArray *const prhs[7], int32_T nlhs,
                         const mxArray *plhs[4])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *prhs_copy_idx_0;
  const mxArray *prhs_copy_idx_1;
  const mxArray *prhs_copy_idx_2;
  real_T(*ellipsoid)[57862080];
  real_T(*pressure)[57862080];
  real_T(*rh)[57862080];
  real_T(*sh)[57862080];
  real_T(*temK)[57862080];
  real_T(*geoid_ground)[1563840];
  real_T b_time;
  real32_T(*pre)[37];
  st.tls = emlrtRootTLSGlobal;
  pressure = (real_T(*)[57862080])mxMalloc(sizeof(real_T[57862080]));
  prhs_copy_idx_0 = emlrtProtectR2012b(prhs[0], 0, true, -1);
  prhs_copy_idx_1 = emlrtProtectR2012b(prhs[1], 1, true, -1);
  prhs_copy_idx_2 = emlrtProtectR2012b(prhs[2], 2, true, -1);
  /* Marshall function inputs */
  ellipsoid = emlrt_marshallIn(&st, emlrtAlias(prhs_copy_idx_0), "ellipsoid");
  temK = emlrt_marshallIn(&st, emlrtAlias(prhs_copy_idx_1), "temK");
  rh = emlrt_marshallIn(&st, emlrtAlias(prhs_copy_idx_2), "rh");
  sh = emlrt_marshallIn(&st, emlrtAlias(prhs[3]), "sh");
  pre = c_emlrt_marshallIn(&st, emlrtAlias(prhs[4]), "pre");
  geoid_ground = e_emlrt_marshallIn(&st, emlrtAlias(prhs[5]), "geoid_ground");
  b_time = g_emlrt_marshallIn(&st, emlrtAliasP(prhs[6]), "time");
  /* Invoke the target function */
  inter_to_ground(*ellipsoid, *temK, *rh, *sh, *pre, *geoid_ground, b_time,
                  *pressure);
  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*pressure);
  if (nlhs > 1) {
    b_emlrt_marshallOut(*temK, prhs_copy_idx_1);
    plhs[1] = prhs_copy_idx_1;
  }
  if (nlhs > 2) {
    b_emlrt_marshallOut(*rh, prhs_copy_idx_2);
    plhs[2] = prhs_copy_idx_2;
  }
  if (nlhs > 3) {
    b_emlrt_marshallOut(*ellipsoid, prhs_copy_idx_0);
    plhs[3] = prhs_copy_idx_0;
  }
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void inter_to_ground_atexit(void)
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
  inter_to_ground_xil_terminate();
  inter_to_ground_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void inter_to_ground_initialize(void)
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
void inter_to_ground_terminate(void)
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
 * File trailer for _coder_inter_to_ground_api.c
 *
 * [EOF]
 */
