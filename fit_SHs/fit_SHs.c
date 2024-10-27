/*
 * File: fit_SHs.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "fit_SHs.h"
#include "driver.h"
#include "fit_SHs_data.h"
#include "fit_SHs_initialize.h"
#include "fit_SHs_types.h"
#include "nullAssignment.h"
#include "rt_nonfinite.h"
#include "tic.h"
#include "toc.h"
#include "unsafeSxfun.h"
#include "rt_nonfinite.h"
#include <math.h>
#include <string.h>

/* Function Declarations */
static void b_binary_expand_op(double in1_data[], int *in1_size,
                               const double in2[2], const double in3_data[],
                               const int *in3_size);

/* Function Definitions */
/*
 * Arguments    : double in1_data[]
 *                int *in1_size
 *                const double in2[2]
 *                const double in3_data[]
 *                const int *in3_size
 * Return Type  : void
 */
static void b_binary_expand_op(double in1_data[], int *in1_size,
                               const double in2[2], const double in3_data[],
                               const int *in3_size)
{
  double in2_data[36];
  double b_in2;
  int i;
  int in2_size;
  int stride_0_0;
  int stride_1_0;
  b_in2 = in2[0];
  if (*in3_size == 1) {
    in2_size = *in1_size;
  } else {
    in2_size = *in3_size;
  }
  stride_0_0 = (*in1_size != 1);
  stride_1_0 = (*in3_size != 1);
  if (*in3_size != 1) {
    *in1_size = *in3_size;
  }
  for (i = 0; i < *in1_size; i++) {
    in2_data[i] = b_in2 * in1_data[i * stride_0_0] - in3_data[i * stride_1_0];
  }
  *in1_size = in2_size;
  if (in2_size - 1 >= 0) {
    memcpy(&in1_data[0], &in2_data[0], in2_size * sizeof(double));
  }
}

/*
 * Arguments    : const double x_data[]
 *                int x_size
 *                const double y_data[]
 *                int y_size
 *                const double params[2]
 *                double varargout_1_data[]
 *                int *varargout_1_size
 * Return Type  : void
 */
void b_fit_SHs_anonFcn2(const double x_data[], int x_size,
                        const double y_data[], int y_size,
                        const double params[2], double varargout_1_data[],
                        int *varargout_1_size)
{
  int k;
  *varargout_1_size = x_size;
  for (k = 0; k < x_size; k++) {
    varargout_1_data[k] = params[1] * x_data[k];
  }
  for (k = 0; k < x_size; k++) {
    varargout_1_data[k] = exp(varargout_1_data[k]);
  }
  if (x_size == y_size) {
    for (k = 0; k < x_size; k++) {
      varargout_1_data[k] = params[0] * varargout_1_data[k] - y_data[k];
    }
  } else {
    b_binary_expand_op(varargout_1_data, varargout_1_size, params, y_data,
                       &y_size);
  }
}

/*
 * Arguments    : c_struct_T *in1
 *                const double in2[2]
 * Return Type  : void
 */
void c_binary_expand_op(c_struct_T *in1, const double in2[2])
{
  double in2_data[36];
  double b_in2;
  int i;
  int in2_size;
  int loop_ub;
  int stride_0_0;
  int stride_1_0;
  b_in2 = in2[0];
  if (in1->nonlin.workspace.fun.workspace.y.size[0] == 1) {
    in2_size = in1->cEq_1.size[0];
  } else {
    in2_size = in1->nonlin.workspace.fun.workspace.y.size[0];
  }
  stride_0_0 = (in1->cEq_1.size[0] != 1);
  stride_1_0 = (in1->nonlin.workspace.fun.workspace.y.size[0] != 1);
  if (in1->nonlin.workspace.fun.workspace.y.size[0] == 1) {
    loop_ub = in1->cEq_1.size[0];
  } else {
    loop_ub = in1->nonlin.workspace.fun.workspace.y.size[0];
  }
  for (i = 0; i < loop_ub; i++) {
    in2_data[i] = b_in2 * in1->cEq_1.data[i * stride_0_0] -
                  in1->nonlin.workspace.fun.workspace.y.data[i * stride_1_0];
  }
  in1->cEq_1.size[0] = in2_size;
  if (in2_size - 1 >= 0) {
    memcpy(&in1->cEq_1.data[0], &in2_data[0], in2_size * sizeof(double));
  }
}

/*
 * Arguments    : const double data[2345760]
 *                const double ellipsoid[2410920]
 *                double d
 *                double SH[65160]
 *                double R_SH[65160]
 * Return Type  : void
 */
void fit_SHs(const double data[2345760], const double ellipsoid[2410920],
             double d, double SH[65160], double R_SH[65160])
{
  double jacob_data[72];
  double fval_data[36];
  double x_data[36];
  double y_data[36];
  double d_expl_temp;
  double e_expl_temp;
  double exitflag;
  double f_expl_temp;
  double g_expl_temp;
  double resnorm;
  int b_i;
  int b_trueCount;
  int i;
  int k;
  int partialTrueCount;
  int x_data_tmp;
  if (!isInitialized_fit_SHs) {
    fit_SHs_initialize();
  }
  tic();
  for (k = 0; k < 65160; k++) {
    SH[k] = rtNaN;
    R_SH[k] = rtNaN;
  }
  for (i = 0; i < 65160; i++) {
    int lat;
    int lon;
    boolean_T bv[36];
    boolean_T bv1[36];
    boolean_T bv2[36];
    boolean_T excludedind_data[36];
    boolean_T exitg1;
    boolean_T guard1 = false;
    boolean_T guard2 = false;
    boolean_T y;
    /* point */
    lat = (int)ceil(((double)i + 1.0) / 360.0) - 1;
    lon = (int)fmod((double)i + 1.0, 360.0) - 1;
    if (lon + 1 == 0) {
      lon = 359;
    }
    for (b_i = 0; b_i < 36; b_i++) {
      k = (lon + 360 * lat) + 65160 * b_i;
      y = rtIsNaN(ellipsoid[k]);
      excludedind_data[b_i] = y;
      bv2[b_i] = !y;
      resnorm = data[k];
      y = rtIsNaN(resnorm);
      bv[b_i] = y;
      bv1[b_i] = ((!y) && (resnorm > 0.0));
    }
    y = true;
    k = 0;
    exitg1 = false;
    while ((!exitg1) && (k < 36)) {
      if (!bv[k]) {
        y = false;
        exitg1 = true;
      } else {
        k++;
      }
    }
    guard1 = false;
    guard2 = false;
    if (y) {
      guard1 = true;
    } else {
      y = true;
      k = 0;
      exitg1 = false;
      while ((!exitg1) && (k < 36)) {
        if ((!bv[k]) && (!excludedind_data[k])) {
          y = false;
          exitg1 = true;
        } else {
          k++;
        }
      }
      if (y) {
        guard1 = true;
      } else {
        int trueCount;
        trueCount = 0;
        for (b_i = 0; b_i < 36; b_i++) {
          if (bv2[b_i] && bv1[b_i]) {
            trueCount++;
          }
        }
        if (trueCount < 10) {
          guard2 = true;
        } else {
          trueCount = 0;
          for (b_i = 0; b_i < 36; b_i++) {
            if (bv2[b_i] && bv1[b_i]) {
              trueCount++;
            }
          }
          if (trueCount < 10) {
            guard2 = true;
          } else {
            double b_expl_temp[2];
            double c_expl_temp[2];
            double params0[2];
            int jacob_size[2];
            char expl_temp[19];
            trueCount = 0;
            k = 0;
            b_trueCount = 0;
            partialTrueCount = 0;
            for (b_i = 0; b_i < 36; b_i++) {
              if (bv2[b_i] && bv1[b_i]) {
                trueCount++;
                x_data_tmp = (lon + 360 * lat) + 65160 * b_i;
                x_data[k] = ellipsoid[x_data_tmp];
                k++;
                b_trueCount++;
                y_data[partialTrueCount] = data[x_data_tmp];
                partialTrueCount++;
              }
            }
            x_data_tmp = trueCount;
            if (d == 6.0) {
              for (k = 0; k < trueCount; k++) {
                excludedind_data[k] = (x_data[k] > 7000.0);
              }
              nullAssignment(x_data, &x_data_tmp, excludedind_data, trueCount);
              nullAssignment(y_data, &b_trueCount, excludedind_data, trueCount);
            }
            /*      if numel(x)<10 | numel(y)<10 */
            /*          SH(lon,lat) = nan; */
            /*          R_SH(lon,lat) = nan; */
            /*          continue */
            /*      end */
            /*  初始参数估计 */
            params0[0] = y_data[0];
            params0[1] = -0.0001;
            driver(x_data, x_data_tmp, y_data, b_trueCount, params0, &resnorm,
                   fval_data, &partialTrueCount, &exitflag, &d_expl_temp,
                   &e_expl_temp, &f_expl_temp, &g_expl_temp, expl_temp,
                   b_expl_temp, c_expl_temp, jacob_data, jacob_size);
            partialTrueCount = x_data_tmp;
            for (k = 0; k < x_data_tmp; k++) {
              fval_data[k] = params0[1] * x_data[k];
            }
            for (k = 0; k < x_data_tmp; k++) {
              fval_data[k] = exp(fval_data[k]);
            }
            if (b_trueCount == 0) {
              resnorm = 0.0;
            } else {
              resnorm = y_data[0];
              for (k = 2; k <= b_trueCount; k++) {
                resnorm += y_data[k - 1];
              }
            }
            resnorm /= (double)b_trueCount;
            /*  总平方和 */
            /*  残差平方和 */
            if (b_trueCount == x_data_tmp) {
              partialTrueCount = b_trueCount;
              for (k = 0; k < b_trueCount; k++) {
                exitflag = y_data[k] - params0[0] * fval_data[k];
                fval_data[k] = exitflag * exitflag;
              }
            } else {
              binary_expand_op(fval_data, &partialTrueCount, y_data,
                               &b_trueCount, params0);
            }
            if (partialTrueCount == 0) {
              d_expl_temp = 0.0;
            } else {
              d_expl_temp = fval_data[0];
              for (k = 2; k <= partialTrueCount; k++) {
                d_expl_temp += fval_data[k - 1];
              }
            }
            for (k = 0; k < b_trueCount; k++) {
              exitflag = y_data[k] - resnorm;
              fval_data[k] = exitflag * exitflag;
            }
            if (b_trueCount == 0) {
              resnorm = 0.0;
            } else {
              resnorm = fval_data[0];
              for (k = 2; k <= b_trueCount; k++) {
                resnorm += fval_data[k - 1];
              }
            }
            k = lon + 360 * lat;
            R_SH[k] = 1.0 - d_expl_temp / resnorm;
            /*  计算R方值 */
            /*      opts = fitoptions( 'Method', 'NonlinearLeastSquares' ); */
            /*  */
            /*      ft = fittype( 'exp1' ); */
            /*      tic */
            /*      [fitResult, gof] = fit(heightValid, data_pValid, ft, opts);
             */
            /*      toc */
            /*      r2 = gof.rsquare; */
            SH[k] = -1.0 / (params0[1] * 1000.0);
            /*      SH(lon,lat) = -1/ (b*1000); */
            /*      R_SH(lon,lat) = R_squared; */
          }
        }
      }
    }
    if (guard2) {
      k = lon + 360 * lat;
      SH[k] = rtNaN;
      R_SH[k] = rtNaN;
    }
    if (guard1) {
      k = lon + 360 * lat;
      SH[k] = rtNaN;
      R_SH[k] = rtNaN;
    }
  }
  toc();
}

/*
 * Arguments    : const double x_data[]
 *                int x_size
 *                const double y_data[]
 *                int y_size
 *                const double params[2]
 *                double varargout_1_data[]
 *                int *varargout_1_size
 * Return Type  : void
 */
void fit_SHs_anonFcn2(const double x_data[], int x_size, const double y_data[],
                      int y_size, const double params[2],
                      double varargout_1_data[], int *varargout_1_size)
{
  int k;
  *varargout_1_size = x_size;
  for (k = 0; k < x_size; k++) {
    varargout_1_data[k] = -0.0001 * x_data[k];
  }
  for (k = 0; k < x_size; k++) {
    varargout_1_data[k] = exp(varargout_1_data[k]);
  }
  if (x_size == y_size) {
    for (k = 0; k < x_size; k++) {
      varargout_1_data[k] = params[0] * varargout_1_data[k] - y_data[k];
    }
  } else {
    b_binary_expand_op(varargout_1_data, varargout_1_size, params, y_data,
                       &y_size);
  }
}

/*
 * File trailer for fit_SHs.c
 *
 * [EOF]
 */
