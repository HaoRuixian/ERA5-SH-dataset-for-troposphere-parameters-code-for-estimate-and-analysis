/*
 * File: timeKeeper.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 03-May-2024 23:56:33
 */

#ifndef TIMEKEEPER_H
#define TIMEKEEPER_H

/* Include Files */
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void b_timeKeeper(double *outTime_tv_sec, double *outTime_tv_nsec);

void savedTime_not_empty_init(void);

void timeKeeper(double newTime_tv_sec, double newTime_tv_nsec);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for timeKeeper.h
 *
 * [EOF]
 */
