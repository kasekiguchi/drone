/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ixamax.c
 *
 * Code generation for function 'ixamax'
 *
 */

/* Include files */
#include "ixamax.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Function Definitions */
int32_T ixamax(const emlrtStack *sp, int32_T n, const real_T x[307])
{
  int32_T idxmax;
  int32_T ix;
  real_T smax;
  int32_T k;
  real_T s;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &t_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  if (n < 1) {
    idxmax = 0;
  } else {
    idxmax = 1;
    if (n > 1) {
      ix = 0;
      smax = muDoubleScalarAbs(x[0]);
      b_st.site = &u_emlrtRSI;
      if (n > 2147483646) {
        c_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (k = 2; k <= n; k++) {
        ix++;
        s = muDoubleScalarAbs(x[ix]);
        if (s > smax) {
          idxmax = k;
          smax = s;
        }
      }
    }
  }

  return idxmax;
}

/* End of code generation (ixamax.c) */
