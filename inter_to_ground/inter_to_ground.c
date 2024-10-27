/*
 * File: inter_to_ground.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 10-Apr-2024 16:52:13
 */

/* Include Files */
#include "inter_to_ground.h"
#include "find.h"
#include "interp1.h"
#include "rt_nonfinite.h"
#include "rt_nonfinite.h"
#include <math.h>
#include <string.h>

/* Function Definitions */
/*
 * Arguments    : double ellipsoid[57862080]
 *                double temK[57862080]
 *                double rh[57862080]
 *                const double sh[57862080]
 *                const float pre[37]
 *                const double geoid_ground[1563840]
 *                double b_time
 *                double pressure[57862080]
 * Return Type  : void
 */
void inter_to_ground(double ellipsoid[57862080], double temK[57862080],
                     double rh[57862080], const double sh[57862080],
                     const float pre[37], const double geoid_ground[1563840],
                     double b_time, double pressure[57862080])
{
  int idx[37];
  int tmp_data[36];
  int b_i;
  int b_j;
  int b_k;
  int c_i;
  int i;
  int i1;
  int j;
  int nb;
  int qEnd;
  int work_tmp;
  for (i = 0; i < 57862080; i++) {
    pressure[i] = rtNaN;
  }
  i = (int)b_time;
  for (b_i = 0; b_i < 65160; b_i++) {
    int lat;
    int lon;
    /* point */
    lat = (int)ceil(((double)b_i + 1.0) / 360.0) - 1;
    lon = (int)fmod((double)b_i + 1.0, 360.0) - 1;
    if (lon + 1 == 0) {
      lon = 359;
    }
    if (i - 1 >= 0) {
      work_tmp = lon + 360 * lat;
    }
    for (j = 0; j < i; j++) {
      double temk_temp_data[37];
      double b_y1[36];
      double tmp2;
      double work;
      int iwork[37];
      int b_work_tmp;
      int i2;
      int k;
      boolean_T exitg1;
      boolean_T guard1 = false;
      /* time */
      /* 判断地面位置与气压层的位置关系，后据此确定内插还是外推 */
      k = 0;
      b_k = 0;
      exitg1 = false;
      while ((!exitg1) && (b_k < 37)) {
        k = b_k;
        i1 = lon + 360 * lat;
        if (geoid_ground[i1 + 65160 * j] <
            ellipsoid[(i1 + 65160 * b_k) + 2410920 * j]) {
          exitg1 = true;
        } else {
          b_k++;
        }
      }
      b_work_tmp = work_tmp + 2410920 * j;
      work = ellipsoid[b_work_tmp];
      for (c_i = 0; c_i < 36; c_i++) {
        tmp2 = work;
        work = ellipsoid[(work_tmp + 65160 * (c_i + 1)) + 2410920 * j];
        b_y1[c_i] = work - tmp2;
      }
      memset(&idx[0], 0, 37U * sizeof(int));
      for (b_k = 0; b_k <= 35; b_k += 2) {
        work = ellipsoid[(work_tmp + 65160 * (b_k + 1)) + 2410920 * j];
        if ((ellipsoid[(work_tmp + 65160 * b_k) + 2410920 * j] <= work) ||
            rtIsNaN(work)) {
          idx[b_k] = b_k + 1;
          idx[b_k + 1] = b_k + 2;
        } else {
          idx[b_k] = b_k + 2;
          idx[b_k + 1] = b_k + 1;
        }
      }
      idx[36] = 37;
      c_i = 2;
      while (c_i < 37) {
        i2 = c_i << 1;
        b_j = 1;
        for (nb = c_i + 1; nb < 38; nb = qEnd + c_i) {
          int kEnd;
          int p;
          int q;
          p = b_j;
          q = nb - 1;
          qEnd = b_j + i2;
          if (qEnd > 38) {
            qEnd = 38;
          }
          b_k = 0;
          kEnd = qEnd - b_j;
          while (b_k + 1 <= kEnd) {
            work = ellipsoid[(work_tmp + 65160 * (idx[q] - 1)) + 2410920 * j];
            i1 = idx[p - 1];
            if ((ellipsoid[(work_tmp + 65160 * (i1 - 1)) + 2410920 * j] <=
                 work) ||
                rtIsNaN(work)) {
              iwork[b_k] = i1;
              p++;
              if (p == nb) {
                while (q + 1 < qEnd) {
                  b_k++;
                  iwork[b_k] = idx[q];
                  q++;
                }
              }
            } else {
              iwork[b_k] = idx[q];
              q++;
              if (q + 1 == qEnd) {
                while (p < nb) {
                  b_k++;
                  iwork[b_k] = idx[p - 1];
                  p++;
                }
              }
            }
            b_k++;
          }
          for (b_k = 0; b_k < kEnd; b_k++) {
            idx[(b_j + b_k) - 1] = iwork[b_k];
          }
          b_j = qEnd;
        }
        c_i = i2;
      }
      for (b_k = 0; b_k < 37; b_k++) {
        temk_temp_data[b_k] =
            ellipsoid[(work_tmp + 65160 * (idx[b_k] - 1)) + 2410920 * j];
      }
      b_k = 0;
      while ((b_k + 1 <= 37) && rtIsInf(temk_temp_data[b_k]) &&
             (temk_temp_data[b_k] < 0.0)) {
        b_k++;
      }
      i2 = b_k;
      b_k = 37;
      while ((b_k >= 1) && rtIsNaN(temk_temp_data[b_k - 1])) {
        b_k--;
      }
      c_i = 37 - b_k;
      exitg1 = false;
      while ((!exitg1) && (b_k >= 1)) {
        work = temk_temp_data[b_k - 1];
        if (rtIsInf(work) && (work > 0.0)) {
          b_k--;
        } else {
          exitg1 = true;
        }
      }
      nb = 0;
      if (i2 > 0) {
        nb = 1;
      }
      while (i2 + 1 <= b_k) {
        work = temk_temp_data[i2];
        do {
          i2++;
        } while (!((i2 + 1 > b_k) || (temk_temp_data[i2] != work)));
        nb++;
        temk_temp_data[nb - 1] = work;
      }
      if (37 - (b_k + c_i) > 0) {
        nb++;
      }
      for (b_j = 0; b_j < c_i; b_j++) {
        nb++;
      }
      if (nb < 1) {
        nb = 0;
      }
      guard1 = false;
      if (nb < 37) {
        guard1 = true;
      } else {
        boolean_T c_y1[36];
        for (i1 = 0; i1 < 36; i1++) {
          c_y1[i1] = (b_y1[i1] == 0.0);
        }
        eml_find(c_y1, tmp_data, &c_i);
        if (c_i > 1) {
          guard1 = true;
        } else {
          for (i1 = 0; i1 < 36; i1++) {
            c_y1[i1] = (b_y1[i1] < 0.0);
          }
          eml_find(c_y1, tmp_data, &c_i);
          if (c_i != 0) {
            guard1 = true;

            /*  外推 */
          } else if (k + 1 == 1) {
            double b_geoid_ground[38];
            double b_temK[37];
            float b_pre[38];
            /*  hum和tem都是直接线性外推 */
            /*  只取37层 */
            work = geoid_ground[(lon + 360 * lat) + 65160 * j];
            for (i1 = 0; i1 < 37; i1++) {
              c_i = (work_tmp + 65160 * i1) + 2410920 * j;
              temk_temp_data[i1] = ellipsoid[c_i];
              b_temK[i1] = temK[c_i];
              b_geoid_ground[i1 + 1] = temK[c_i];
            }
            b_geoid_ground[0] = interp1(temk_temp_data, b_temK, work);
            for (i1 = 0; i1 < 37; i1++) {
              c_i = (work_tmp + 65160 * i1) + 2410920 * j;
              temK[c_i] = b_geoid_ground[i1];
              temk_temp_data[i1] = ellipsoid[c_i];
              b_temK[i1] = rh[c_i];
            }
            b_geoid_ground[0] = interp1(temk_temp_data, b_temK, work);
            for (i1 = 0; i1 < 37; i1++) {
              b_geoid_ground[i1 + 1] =
                  rh[(work_tmp + 65160 * i1) + 2410920 * j];
            }
            for (i1 = 0; i1 < 37; i1++) {
              rh[(work_tmp + 65160 * i1) + 2410920 * j] = b_geoid_ground[i1];
            }
            b_geoid_ground[0] = work;
            for (i1 = 0; i1 < 37; i1++) {
              b_geoid_ground[i1 + 1] =
                  ellipsoid[(work_tmp + 65160 * i1) + 2410920 * j];
            }
            for (i1 = 0; i1 < 37; i1++) {
              ellipsoid[(work_tmp + 65160 * i1) + 2410920 * j] =
                  b_geoid_ground[i1];
            }
            /* pre特殊，需要指数外推。指数的系数是根据virtual temperature。 */
            /* 根据gpt2w代码中的公式求取。其实后续也不会用到pre */
            /* virtual temperature, 需要比湿 */
            /* 值为负 */
            b_pre[0] =
                pre[0] *
                (float)exp(-(0.28404961725 /
                             (8.3143 * (temK[b_work_tmp + 65160] *
                                        (0.6077 * sh[b_work_tmp] + 1.0)))) *
                           (work - ellipsoid[b_work_tmp + 65160]));
            for (i1 = 0; i1 < 37; i1++) {
              b_pre[i1 + 1] = pre[i1];
              pressure[(work_tmp + 65160 * i1) + 2410920 * j] = b_pre[i1];
            }
            /* 内插 */
          } else {
            double b_temK[37];
            float pre_temp_data[37];
            float pre_temp_tmp;
            signed char szb_idx_0;
            /* pre的内插，ec直接用相邻俩个气压层的比值 */
            /* 两个气压层之间的高度差 */
            /* 两层气压之间的比值 */
            /* 结果已经是负值，后续不用加负号 */
            c_i = 38 - k;
            work = ellipsoid[(work_tmp + 65160 * (k - 1)) + 2410920 * j];
            pre_temp_tmp = pre[k - 1];
            tmp2 = geoid_ground[(lon + 360 * lat) + 65160 * j];
            pre_temp_data[0] =
                pre_temp_tmp *
                expf(logf(pre[k] / pre_temp_tmp) /
                     (float)(ellipsoid[(work_tmp + 65160 * k) + 2410920 * j] -
                             work) *
                     (float)(tmp2 - work));
            i2 = -k;
            for (i1 = 0; i1 <= i2 + 36; i1++) {
              pre_temp_data[i1 + 1] = pre[k + i1];
            }
            for (i1 = 0; i1 < c_i; i1++) {
              pressure[(work_tmp + 65160 * i1) + 2410920 * j] =
                  pre_temp_data[i1];
            }
            /*  hum和tem都是直接线性内插 */
            szb_idx_0 = 1;
            if (37 - k != 1) {
              szb_idx_0 = (signed char)(37 - k);
            }
            for (i1 = 0; i1 < 37; i1++) {
              c_i = (work_tmp + 65160 * i1) + 2410920 * j;
              temk_temp_data[i1] = ellipsoid[c_i];
              b_temK[i1] = temK[c_i];
            }
            c_i = szb_idx_0 + 1;
            temk_temp_data[0] = interp1(temk_temp_data, b_temK, tmp2);
            i2 = szb_idx_0;
            for (i1 = 0; i1 < i2; i1++) {
              temk_temp_data[i1 + 1] =
                  temK[(work_tmp + 65160 * (k + i1)) + 2410920 * j];
            }
            for (i1 = 0; i1 < c_i; i1++) {
              temK[(work_tmp + 65160 * i1) + 2410920 * j] = temk_temp_data[i1];
            }
            szb_idx_0 = 1;
            if (37 - k != 1) {
              szb_idx_0 = (signed char)(37 - k);
            }
            for (i1 = 0; i1 < 37; i1++) {
              c_i = (work_tmp + 65160 * i1) + 2410920 * j;
              temk_temp_data[i1] = ellipsoid[c_i];
              b_temK[i1] = rh[c_i];
            }
            c_i = szb_idx_0 + 1;
            temk_temp_data[0] = interp1(temk_temp_data, b_temK, tmp2);
            i2 = szb_idx_0;
            for (i1 = 0; i1 < i2; i1++) {
              temk_temp_data[i1 + 1] =
                  rh[(work_tmp + 65160 * (k + i1)) + 2410920 * j];
            }
            for (i1 = 0; i1 < c_i; i1++) {
              rh[(work_tmp + 65160 * i1) + 2410920 * j] = temk_temp_data[i1];
            }
            szb_idx_0 = 1;
            if (37 - k != 1) {
              szb_idx_0 = (signed char)(37 - k);
            }
            c_i = szb_idx_0 + 1;
            temk_temp_data[0] = tmp2;
            i2 = szb_idx_0;
            for (i1 = 0; i1 < i2; i1++) {
              temk_temp_data[i1 + 1] =
                  ellipsoid[(work_tmp + 65160 * (k + i1)) + 2410920 * j];
            }
            for (i1 = 0; i1 < c_i; i1++) {
              ellipsoid[(work_tmp + 65160 * i1) + 2410920 * j] =
                  temk_temp_data[i1];
            }
          }
        }
      }
      if (guard1) {
        /*  find wrong data */
        for (i1 = 0; i1 < 37; i1++) {
          c_i = (work_tmp + 65160 * i1) + 2410920 * j;
          pressure[c_i] = rtNaN;
          temK[c_i] = rtNaN;
          rh[c_i] = rtNaN;
        }
      }
    }
  }
}

/*
 * File trailer for inter_to_ground.c
 *
 * [EOF]
 */
