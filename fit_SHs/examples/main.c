/*
 * File: main.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
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
#include "fit_SHs.h"
#include "fit_SHs_terminate.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static void argInit_360x181x36_real_T(double result[2345760]);

static void argInit_360x181x37_real_T(double result[2410920]);

static double argInit_real_T(void);

static void main_fit_SHs(void);

/* Function Definitions */
/*
 * Arguments    : double result[2345760]
 * Return Type  : void
 */
static void argInit_360x181x36_real_T(double result[2345760])
{
  int idx0;
  int idx1;
  int idx2;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 360; idx0++) {
    for (idx1 = 0; idx1 < 181; idx1++) {
      for (idx2 = 0; idx2 < 36; idx2++) {
        /* Set the value of the array element.
Change this value to the value that the application requires. */
        result[(idx0 + 360 * idx1) + 65160 * idx2] = argInit_real_T();
      }
    }
  }
}

/*
 * Arguments    : double result[2410920]
 * Return Type  : void
 */
static void argInit_360x181x37_real_T(double result[2410920])
{
  int idx0;
  int idx1;
  int idx2;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 360; idx0++) {
    for (idx1 = 0; idx1 < 181; idx1++) {
      for (idx2 = 0; idx2 < 37; idx2++) {
        /* Set the value of the array element.
Change this value to the value that the application requires. */
        result[(idx0 + 360 * idx1) + 65160 * idx2] = argInit_real_T();
      }
    }
  }
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
static void main_fit_SHs(void)
{
  static double dv1[2410920];
  static double dv[2345760];
  static double R_SH[65160];
  static double SH[65160];
  /* Initialize function 'fit_SHs' input arguments. */
  /* Initialize function input argument 'data'. */
  /* Initialize function input argument 'ellipsoid'. */
  /* Call the entry-point 'fit_SHs'. */
  argInit_360x181x36_real_T(dv);
  argInit_360x181x37_real_T(dv1);
  fit_SHs(dv, dv1, argInit_real_T(), SH, R_SH);
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
  main_fit_SHs();
  /* Terminate the application.
You do not need to do this more than one time. */
  fit_SHs_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
