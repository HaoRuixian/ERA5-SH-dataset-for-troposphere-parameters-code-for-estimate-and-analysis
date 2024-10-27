/*
 * File: fit_SHs_types.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

#ifndef FIT_SHS_TYPES_H
#define FIT_SHS_TYPES_H

/* Include Files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T_36
#define struct_emxArray_real_T_36
struct emxArray_real_T_36 {
  double data[36];
  int size[1];
};
#endif /* struct_emxArray_real_T_36 */
#ifndef typedef_emxArray_real_T_36
#define typedef_emxArray_real_T_36
typedef struct emxArray_real_T_36 emxArray_real_T_36;
#endif /* typedef_emxArray_real_T_36 */

#ifndef typedef_struct_T
#define typedef_struct_T
typedef struct {
  emxArray_real_T_36 x;
  emxArray_real_T_36 y;
} struct_T;
#endif /* typedef_struct_T */

#ifndef typedef_anonymous_function
#define typedef_anonymous_function
typedef struct {
  struct_T workspace;
} anonymous_function;
#endif /* typedef_anonymous_function */

#ifndef typedef_b_struct_T
#define typedef_b_struct_T
typedef struct {
  anonymous_function fun;
} b_struct_T;
#endif /* typedef_b_struct_T */

#ifndef typedef_b_anonymous_function
#define typedef_b_anonymous_function
typedef struct {
  b_struct_T workspace;
} b_anonymous_function;
#endif /* typedef_b_anonymous_function */

#ifndef typedef_c_struct_T
#define typedef_c_struct_T
typedef struct {
  b_anonymous_function nonlin;
  double f_1;
  emxArray_real_T_36 cEq_1;
  double f_2;
  emxArray_real_T_36 cEq_2;
  int nVar;
  int mIneq;
  int mEq;
  int numEvals;
  boolean_T SpecifyObjectiveGradient;
  boolean_T SpecifyConstraintGradient;
  boolean_T isEmptyNonlcon;
  boolean_T hasLB[2];
  boolean_T hasUB[2];
  boolean_T hasBounds;
  int FiniteDifferenceType;
} c_struct_T;
#endif /* typedef_c_struct_T */

#endif
/*
 * File trailer for fit_SHs_types.h
 *
 * [EOF]
 */
