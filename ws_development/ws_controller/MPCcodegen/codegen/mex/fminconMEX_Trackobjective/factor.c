/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factor.c
 *
 * Code generation for function 'factor'
 *
 */

/* Include files */
#include "factor.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xpotrf.h"

/* Function Definitions */
void factor(const emlrtStack *sp, h_struct_T *obj, const real_T A[4356], int32_T
            ndims, int32_T ldA)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T idx;
  int32_T ix0;
  int32_T iy0;
  int32_T k;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  obj->ndims = ndims;
  st.site = &te_emlrtRSI;
  if ((1 <= ndims) && (ndims > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < ndims; idx++) {
    ix0 = ldA * idx;
    iy0 = obj->ldm * idx;
    st.site = &te_emlrtRSI;
    for (k = 0; k < ndims; k++) {
      obj->FMat->data[iy0 + k] = A[ix0 + k];
    }
  }

  st.site = &te_emlrtRSI;
  obj->info = xpotrf(&st, ndims, obj->FMat, obj->ldm);
}

/* End of code generation (factor.c) */
