/*
 * File: fit_SHs_initialize.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

/* Include Files */
#include "fit_SHs_initialize.h"
#include "CoderTimeAPI.h"
#include "fit_SHs_data.h"
#include "rt_nonfinite.h"
#include "timeKeeper.h"

/* Function Definitions */
/*
 * Arguments    : void
 * Return Type  : void
 */
void fit_SHs_initialize(void)
{
  savedTime_not_empty_init();
  freq_not_empty_init();
  isInitialized_fit_SHs = true;
}

/*
 * File trailer for fit_SHs_initialize.c
 *
 * [EOF]
 */
