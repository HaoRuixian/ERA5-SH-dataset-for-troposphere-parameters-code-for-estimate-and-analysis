/*
 * File: main.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 10-Apr-2024 16:52:13
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

/* Include Files */
#include "main.h"
#include "inter_to_ground.h"
#include "inter_to_ground_terminate.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Declarations */
static void argInit_360x181x24_real_T(double result[1563840]);

static void argInit_360x181x37x24_real_T(double result[57862080]);

static void argInit_37x1_real32_T(float result[37]);

static float argInit_real32_T(void);

static double argInit_real_T(void);

static void main_inter_to_ground(void);

/* Function Definitions */
/*
 * Arguments    : double result[1563840]
 * Return Type  : void
 */
static void argInit_360x181x24_real_T(double result[1563840])
{
  int idx0;
  int idx1;
  int idx2;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 360; idx0++) {
    for (idx1 = 0; idx1 < 181; idx1++) {
      for (idx2 = 0; idx2 < 24; idx2++) {
        /* Set the value of the array element.
Change this value to the value that the application requires. */
        result[(idx0 + 360 * idx1) + 65160 * idx2] = argInit_real_T();
      }
    }
  }
}

/*
 * Arguments    : double result[57862080]
 * Return Type  : void
 */
static void argInit_360x181x37x24_real_T(double result[57862080])
{
  int idx0;
  int idx1;
  int idx2;
  int idx3;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 360; idx0++) {
    for (idx1 = 0; idx1 < 181; idx1++) {
      for (idx2 = 0; idx2 < 37; idx2++) {
        for (idx3 = 0; idx3 < 24; idx3++) {
          /* Set the value of the array element.
Change this value to the value that the application requires. */
          result[((idx0 + 360 * idx1) + 65160 * idx2) + 2410920 * idx3] =
              argInit_real_T();
        }
      }
    }
  }
}

/*
 * Arguments    : float result[37]
 * Return Type  : void
 */
static void argInit_37x1_real32_T(float result[37])
{
  int idx0;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 37; idx0++) {
    /* Set the value of the array element.
Change this value to the value that the application requires. */
    result[idx0] = argInit_real32_T();
  }
}

/*
 * Arguments    : void
 * Return Type  : float
 */
static float argInit_real32_T(void)
{
  return 0.0F;
}

/*
 * Arguments    : void
 * Return Type  : double
 */
static double argInit_real_T(void)
{
  return 0.0;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void main_inter_to_ground(void)
{
  static double b_temK[57862080];
  static double ellipsoid[57862080];
  static double pressure[57862080];
  static double rh[57862080];
  static double temK[57862080];
  static double dv[1563840];
  int i;
  /* Initialize function 'inter_to_ground' input arguments. */
  /* Initialize function input argument 'ellipsoid'. */
  argInit_360x181x37x24_real_T(temK);
  /* Initialize function input argument 'temK'. */
  /* Initialize function input argument 'rh'. */
  /* Initialize function input argument 'sh'. */
  /* Initialize function input argument 'pre'. */
  /* Initialize function input argument 'geoid_ground'. */
  /* Call the entry-point 'inter_to_ground'. */
  for (i = 0; i < 57862080; i++) {
    double d;
    d = temK[i];
    rh[i] = d;
    ellipsoid[i] = d;
  }
  float fv[37];
  argInit_37x1_real32_T(fv);
  argInit_360x181x24_real_T(dv);
  memcpy(&b_temK[0], &temK[0], 57862080U * sizeof(double));
  inter_to_ground(ellipsoid, temK, rh, b_temK, fv, dv, argInit_real_T(),
                  pressure);
}

/*
 * Arguments    : int argc
 *                char **argv
 * Return Type  : int
 */
int main(int argc, char **argv)
{
  (void)argc;
  (void)argv;
  /* The initialize function is being called automatically from your entry-point
   * function. So, a call to initialize is not included here. */
  /* Invoke the entry-point functions.
You can call entry-point functions multiple times. */
  main_inter_to_ground();
  /* Terminate the application.
You do not need to do this more than one time. */
  inter_to_ground_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
