/*
 * File: inter_to_ground.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 10-Apr-2024 16:52:13
 */

#ifndef INTER_TO_GROUND_H
#define INTER_TO_GROUND_H

/* Include Files */
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern void inter_to_ground(double ellipsoid[57862080], double temK[57862080],
                            double rh[57862080], const double sh[57862080],
                            const float pre[37],
                            const double geoid_ground[1563840], double b_time,
                            double pressure[57862080]);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for inter_to_ground.h
 *
 * [EOF]
 */
