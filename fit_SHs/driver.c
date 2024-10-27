/*
 * File: driver.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "driver.h"
#include "checkStoppingCriteria.h"
#include "computeFiniteDifferences.h"
#include "fit_SHs.h"
#include "fit_SHs_types.h"
#include "linearLeastSquares.h"
#include "rt_nonfinite.h"
#include "xgemv.h"
#include "rt_nonfinite.h"
#include <math.h>
#include <string.h>

/* Function Definitions */
/*
 * Arguments    : const double fun_workspace_x_data[]
 *                int fun_workspace_x_size
 *                const double fun_workspace_y_data[]
 *                int fun_workspace_y_size
 *                double x0[2]
 *                double *resnorm
 *                double fCurrent_data[]
 *                int *fCurrent_size
 *                double *exitflag
 *                double *output_iterations
 *                double *output_funcCount
 *                double *output_stepsize
 *                double *output_firstorderopt
 *                char output_algorithm[19]
 *                double lambda_lower[2]
 *                double lambda_upper[2]
 *                double jacobian_data[]
 *                int jacobian_size[2]
 * Return Type  : void
 */
void driver(const double fun_workspace_x_data[], int fun_workspace_x_size,
            const double fun_workspace_y_data[], int fun_workspace_y_size,
            double x0[2], double *resnorm, double fCurrent_data[],
            int *fCurrent_size, double *exitflag, double *output_iterations,
            double *output_funcCount, double *output_stepsize,
            double *output_firstorderopt, char output_algorithm[19],
            double lambda_lower[2], double lambda_upper[2],
            double jacobian_data[], int jacobian_size[2])
{
  static const char cv[19] = {'l', 'e', 'v', 'e', 'n', 'b', 'e', 'r', 'g', '-',
                              'm', 'a', 'r', 'q', 'u', 'a', 'r', 'd', 't'};
  c_struct_T FiniteDifferences;
  c_struct_T obj;
  double B_data[76];
  double augJacobian_data[76];
  double JacCeqTrans_data[72];
  double rhs_data[38];
  double fNew_data[36];
  double f_temp_data[36];
  double a__3[2];
  double dx[2];
  double gradf[2];
  double b_gamma;
  double funDiff;
  double normGradF;
  double relFactor;
  double resnormNew;
  double sqrtGamma;
  int augJacobian_size[2];
  int aIdx;
  int bIdx;
  int b_i;
  int f_temp_size;
  int funcCount;
  int i;
  int iter;
  int j;
  int k;
  int m_temp;
  int m_tmp;
  boolean_T exitg1;
  boolean_T stepSuccessful;
  for (i = 0; i < 19; i++) {
    output_algorithm[i] = cv[i];
  }
  dx[0] = rtInf;
  dx[1] = rtInf;
  funDiff = rtInf;
  iter = 0;
  fit_SHs_anonFcn2(fun_workspace_x_data, fun_workspace_x_size,
                   fun_workspace_y_data, fun_workspace_y_size, x0, f_temp_data,
                   &f_temp_size);
  m_temp = f_temp_size;
  m_tmp = f_temp_size - 1;
  *fCurrent_size = f_temp_size;
  if (m_tmp >= 0) {
    memcpy(&fCurrent_data[0], &f_temp_data[0], (m_tmp + 1) * sizeof(double));
  }
  augJacobian_size[0] = f_temp_size + 2;
  augJacobian_size[1] = 2;
  for (j = 0; j < 2; j++) {
    aIdx = j * f_temp_size;
    bIdx = j * (f_temp_size + 2);
    for (b_i = 0; b_i <= m_tmp; b_i++) {
      augJacobian_data[bIdx + b_i] = jacobian_data[aIdx + b_i];
    }
  }
  *resnorm = 0.0;
  if (f_temp_size >= 1) {
    for (k = 0; k < f_temp_size; k++) {
      sqrtGamma = fCurrent_data[k];
      *resnorm += sqrtGamma * sqrtGamma;
    }
  }
  obj.nonlin.workspace.fun.workspace.x.size[0] = fun_workspace_x_size;
  if (fun_workspace_x_size - 1 >= 0) {
    memcpy(&obj.nonlin.workspace.fun.workspace.x.data[0],
           &fun_workspace_x_data[0], fun_workspace_x_size * sizeof(double));
  }
  obj.nonlin.workspace.fun.workspace.y.size[0] = fun_workspace_y_size;
  if (fun_workspace_y_size - 1 >= 0) {
    memcpy(&obj.nonlin.workspace.fun.workspace.y.data[0],
           &fun_workspace_y_data[0], fun_workspace_y_size * sizeof(double));
  }
  obj.f_1 = 0.0;
  obj.cEq_1.size[0] = f_temp_size;
  obj.f_2 = 0.0;
  obj.cEq_2.size[0] = f_temp_size;
  obj.nVar = 2;
  obj.mIneq = 0;
  obj.mEq = f_temp_size;
  obj.numEvals = 0;
  obj.SpecifyObjectiveGradient = false;
  obj.SpecifyConstraintGradient = false;
  obj.isEmptyNonlcon = (f_temp_size == 0);
  obj.FiniteDifferenceType = 0;
  obj.hasBounds = false;
  obj.hasLB[0] = false;
  obj.hasUB[0] = false;
  a__3[0] = x0[0];
  obj.hasLB[1] = false;
  obj.hasUB[1] = false;
  a__3[1] = x0[1];
  computeFiniteDifferences(&obj, fCurrent_data, a__3, JacCeqTrans_data);
  for (i = 0; i < 2; i++) {
    for (aIdx = 0; aIdx < f_temp_size; aIdx++) {
      augJacobian_data[aIdx + (f_temp_size + 2) * i] =
          JacCeqTrans_data[i + 2 * aIdx];
    }
  }
  funcCount = obj.numEvals + 1;
  b_gamma = 0.01;
  augJacobian_data[f_temp_size + 1] = 0.0;
  augJacobian_data[f_temp_size] = 0.1;
  aIdx = (f_temp_size + 2) << 1;
  augJacobian_data[aIdx - 2] = 0.0;
  augJacobian_data[aIdx - 1] = 0.0;
  augJacobian_data[(f_temp_size + f_temp_size) + 3] = 0.1;
  aIdx = f_temp_size << 1;
  if (aIdx - 1 >= 0) {
    memcpy(&B_data[0], &jacobian_data[0], aIdx * sizeof(double));
  }
  for (j = 0; j < 2; j++) {
    aIdx = j * (f_temp_size + 2);
    bIdx = j * f_temp_size;
    for (b_i = 0; b_i <= m_tmp; b_i++) {
      B_data[bIdx + b_i] = augJacobian_data[aIdx + b_i];
    }
  }
  jacobian_size[0] = f_temp_size;
  jacobian_size[1] = 2;
  aIdx = f_temp_size * 2;
  if (aIdx - 1 >= 0) {
    memcpy(&jacobian_data[0], &B_data[0], aIdx * sizeof(double));
  }
  xgemv(f_temp_size, B_data, f_temp_size, fCurrent_data, gradf);
  sqrtGamma = 0.0;
  stepSuccessful = true;
  normGradF = 0.0;
  resnormNew = fabs(gradf[0]);
  if (rtIsNaN(resnormNew) || (resnormNew > 0.0)) {
    sqrtGamma = resnormNew;
  }
  if (rtIsNaN(resnormNew) || (resnormNew > 0.0)) {
    normGradF = resnormNew;
  }
  resnormNew = fabs(gradf[1]);
  if (rtIsNaN(resnormNew) || (resnormNew > sqrtGamma)) {
    sqrtGamma = resnormNew;
  }
  if (rtIsNaN(resnormNew) || (resnormNew > normGradF)) {
    normGradF = resnormNew;
  }
  relFactor = fmax(sqrtGamma, 1.0);
  if (normGradF <= 1.0E-10 * relFactor) {
    bIdx = 1;
  } else if (obj.numEvals + 1 >= 400) {
    bIdx = 0;
  } else {
    bIdx = -5;
  }
  exitg1 = false;
  while ((!exitg1) && (bIdx == -5)) {
    double xp[2];
    boolean_T evalOK;
    boolean_T guard1 = false;
    for (i = 0; i < *fCurrent_size; i++) {
      f_temp_data[i] = -fCurrent_data[i];
    }
    if (m_tmp >= 0) {
      memcpy(&rhs_data[0], &f_temp_data[0], (m_tmp + 1) * sizeof(double));
    }
    rhs_data[m_tmp + 1] = 0.0;
    rhs_data[m_tmp + 2] = 0.0;
    linearLeastSquares(augJacobian_data, augJacobian_size, rhs_data, dx,
                       m_temp + 2);
    xp[0] = x0[0] + dx[0];
    xp[1] = x0[1] + dx[1];
    b_fit_SHs_anonFcn2(fun_workspace_x_data, fun_workspace_x_size,
                       fun_workspace_y_data, fun_workspace_y_size, xp,
                       f_temp_data, &f_temp_size);
    if (m_tmp >= 0) {
      memcpy(&fNew_data[0], &f_temp_data[0], (m_tmp + 1) * sizeof(double));
    }
    resnormNew = 0.0;
    if (m_temp >= 1) {
      for (k = 0; k <= m_tmp; k++) {
        sqrtGamma = fNew_data[k];
        resnormNew += sqrtGamma * sqrtGamma;
      }
    }
    evalOK = true;
    for (b_i = 0; b_i <= m_tmp; b_i++) {
      if ((!evalOK) || (rtIsInf(fNew_data[b_i]) || rtIsNaN(fNew_data[b_i]))) {
        evalOK = false;
      }
    }
    funcCount++;
    guard1 = false;
    if ((resnormNew < *resnorm) && evalOK) {
      iter++;
      funDiff = fabs(resnormNew - *resnorm) / *resnorm;
      *resnorm = resnormNew;
      a__3[0] = xp[0];
      a__3[1] = xp[1];
      FiniteDifferences = obj;
      evalOK = computeFiniteDifferences(&FiniteDifferences, fNew_data, a__3,
                                        JacCeqTrans_data);
      funcCount += FiniteDifferences.numEvals;
      for (i = 0; i < 2; i++) {
        for (aIdx = 0; aIdx < *fCurrent_size; aIdx++) {
          augJacobian_data[aIdx + augJacobian_size[0] * i] =
              JacCeqTrans_data[i + 2 * aIdx];
        }
      }
      if (*fCurrent_size - 1 >= 0) {
        memcpy(&fCurrent_data[0], &fNew_data[0],
               *fCurrent_size * sizeof(double));
      }
      k = jacobian_size[0];
      aIdx = jacobian_size[0] * 2;
      if (aIdx - 1 >= 0) {
        memcpy(&B_data[0], &jacobian_data[0], aIdx * sizeof(double));
      }
      i = m_temp - 1;
      for (j = 0; j < 2; j++) {
        aIdx = j * (m_tmp + 3);
        bIdx = j * m_temp;
        for (b_i = 0; b_i <= i; b_i++) {
          B_data[bIdx + b_i] = augJacobian_data[aIdx + b_i];
        }
      }
      jacobian_size[1] = 2;
      aIdx = k * 2;
      if (aIdx - 1 >= 0) {
        memcpy(&jacobian_data[0], &B_data[0], aIdx * sizeof(double));
      }
      if (evalOK) {
        x0[0] = xp[0];
        x0[1] = xp[1];
        if (stepSuccessful) {
          b_gamma *= 0.1;
        }
        stepSuccessful = true;
        guard1 = true;
      } else {
        bIdx = 2;
        aIdx = m_temp << 1;
        for (k = 0; k < aIdx; k++) {
          jacobian_data[k] = rtNaN;
        }
        exitg1 = true;
      }
    } else {
      b_gamma *= 10.0;
      stepSuccessful = false;
      i = m_temp - 1;
      for (j = 0; j < 2; j++) {
        aIdx = j * m_temp;
        bIdx = j * (m_tmp + 3);
        for (b_i = 0; b_i <= i; b_i++) {
          augJacobian_data[bIdx + b_i] = jacobian_data[aIdx + b_i];
        }
      }
      guard1 = true;
    }
    if (guard1) {
      sqrtGamma = sqrt(b_gamma);
      augJacobian_data[m_temp + 1] = 0.0;
      augJacobian_data[m_temp] = sqrtGamma;
      aIdx = (m_temp + 2) << 1;
      augJacobian_data[aIdx - 2] = 0.0;
      augJacobian_data[aIdx - 1] = 0.0;
      augJacobian_data[(m_temp + augJacobian_size[0]) + 1] = sqrtGamma;
      xgemv(m_temp, jacobian_data, m_temp, fCurrent_data, gradf);
      bIdx = checkStoppingCriteria(gradf, relFactor, funDiff, x0, dx, funcCount,
                                   stepSuccessful, &iter);
      if (bIdx != -5) {
        exitg1 = true;
      }
    }
  }
  *exitflag = bIdx;
  *output_firstorderopt = 0.0;
  *output_iterations = iter;
  *output_funcCount = funcCount;
  normGradF = 3.3121686421112381E-170;
  sqrtGamma = fabs(gradf[0]);
  if (rtIsNaN(sqrtGamma) || (sqrtGamma > 0.0)) {
    *output_firstorderopt = sqrtGamma;
  }
  sqrtGamma = fabs(dx[0]);
  if (sqrtGamma > 3.3121686421112381E-170) {
    relFactor = 1.0;
    normGradF = sqrtGamma;
  } else {
    resnormNew = sqrtGamma / 3.3121686421112381E-170;
    relFactor = resnormNew * resnormNew;
  }
  lambda_lower[0] = 0.0;
  lambda_upper[0] = 0.0;
  sqrtGamma = fabs(gradf[1]);
  if (rtIsNaN(sqrtGamma) || (sqrtGamma > *output_firstorderopt)) {
    *output_firstorderopt = sqrtGamma;
  }
  sqrtGamma = fabs(dx[1]);
  if (sqrtGamma > normGradF) {
    resnormNew = normGradF / sqrtGamma;
    relFactor = relFactor * resnormNew * resnormNew + 1.0;
    normGradF = sqrtGamma;
  } else {
    resnormNew = sqrtGamma / normGradF;
    relFactor += resnormNew * resnormNew;
  }
  lambda_lower[1] = 0.0;
  lambda_upper[1] = 0.0;
  *output_stepsize = normGradF * sqrt(relFactor);
}

/*
 * File trailer for driver.c
 *
 * [EOF]
 */
