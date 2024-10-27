/*
 * File: computeFiniteDifferences.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "computeFiniteDifferences.h"
#include "fit_SHs.h"
#include "fit_SHs_types.h"
#include "rt_nonfinite.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Definitions */
/*
 * Arguments    : c_struct_T *obj
 *                const double cEqCurrent_data[]
 *                double xk[2]
 *                double JacCeqTrans_data[]
 * Return Type  : boolean_T
 */
boolean_T computeFiniteDifferences(c_struct_T *obj,
                                   const double cEqCurrent_data[], double xk[2],
                                   double JacCeqTrans_data[])
{
  int k;
  int nx;
  boolean_T evalOK;
  if (obj->isEmptyNonlcon) {
    evalOK = true;
  } else {
    int idx;
    boolean_T exitg1;
    evalOK = true;
    obj->numEvals = 0;
    idx = 0;
    exitg1 = false;
    while ((!exitg1) && (idx < 2)) {
      double b_xk;
      double deltaX;
      double temp;
      boolean_T guard1 = false;
      deltaX = 1.4901161193847656E-8 * (1.0 - 2.0 * (double)(xk[idx] < 0.0)) *
               fmax(fabs(xk[idx]), 1.0);
      evalOK = true;
      temp = xk[idx];
      xk[idx] += deltaX;
      b_xk = xk[1];
      obj->cEq_1.size[0] = obj->nonlin.workspace.fun.workspace.x.size[0];
      nx = obj->nonlin.workspace.fun.workspace.x.size[0];
      for (k = 0; k < nx; k++) {
        obj->cEq_1.data[k] =
            b_xk * obj->nonlin.workspace.fun.workspace.x.data[k];
      }
      nx = obj->cEq_1.size[0];
      for (k = 0; k < nx; k++) {
        obj->cEq_1.data[k] = exp(obj->cEq_1.data[k]);
      }
      if (obj->cEq_1.size[0] == obj->nonlin.workspace.fun.workspace.y.size[0]) {
        b_xk = xk[0];
        nx = obj->cEq_1.size[0];
        for (k = 0; k < nx; k++) {
          obj->cEq_1.data[k] = b_xk * obj->cEq_1.data[k] -
                               obj->nonlin.workspace.fun.workspace.y.data[k];
        }
      } else {
        c_binary_expand_op(obj, xk);
      }
      nx = 0;
      while (evalOK && (nx + 1 <= obj->mEq)) {
        evalOK = ((!rtIsInf(obj->cEq_1.data[nx])) &&
                  (!rtIsNaN(obj->cEq_1.data[nx])));
        nx++;
      }
      xk[idx] = temp;
      obj->f_1 = 0.0;
      obj->numEvals++;
      guard1 = false;
      if (!evalOK) {
        deltaX = -deltaX;
        evalOK = true;
        temp = xk[idx];
        xk[idx] += deltaX;
        b_xk = xk[1];
        obj->cEq_1.size[0] = obj->nonlin.workspace.fun.workspace.x.size[0];
        nx = obj->nonlin.workspace.fun.workspace.x.size[0];
        for (k = 0; k < nx; k++) {
          obj->cEq_1.data[k] =
              b_xk * obj->nonlin.workspace.fun.workspace.x.data[k];
        }
        nx = obj->cEq_1.size[0];
        for (k = 0; k < nx; k++) {
          obj->cEq_1.data[k] = exp(obj->cEq_1.data[k]);
        }
        if (obj->cEq_1.size[0] ==
            obj->nonlin.workspace.fun.workspace.y.size[0]) {
          b_xk = xk[0];
          nx = obj->cEq_1.size[0];
          for (k = 0; k < nx; k++) {
            obj->cEq_1.data[k] = b_xk * obj->cEq_1.data[k] -
                                 obj->nonlin.workspace.fun.workspace.y.data[k];
          }
        } else {
          c_binary_expand_op(obj, xk);
        }
        nx = 0;
        while (evalOK && (nx + 1 <= obj->mEq)) {
          evalOK = ((!rtIsInf(obj->cEq_1.data[nx])) &&
                    (!rtIsNaN(obj->cEq_1.data[nx])));
          nx++;
        }
        xk[idx] = temp;
        obj->f_1 = 0.0;
        obj->numEvals++;
        if (!evalOK) {
          exitg1 = true;
        } else {
          guard1 = true;
        }
      } else {
        guard1 = true;
      }
      if (guard1) {
        k = obj->mEq;
        for (nx = 0; nx < k; nx++) {
          JacCeqTrans_data[idx + (nx << 1)] =
              (obj->cEq_1.data[nx] - cEqCurrent_data[nx]) / deltaX;
        }
        idx++;
      }
    }
  }
  return evalOK;
}

/*
 * File trailer for computeFiniteDifferences.c
 *
 * [EOF]
 */
