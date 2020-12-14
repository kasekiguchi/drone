/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * autoEval.h
 *
 * Code generation for function 'autoEval'
 *
 */

#pragma once

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "F_HL_MPCfunc_types.h"

/* Function Declarations */
void autoEval(const real_T in1[132], const real_T in2[4], real_T Qm, real_T Qmf,
              real_T Qt, real_T Qtf, const real_T in7[4], real_T Ws, real_T Wr,
              const real_T in10[11], const real_T in11[11], real_T BLD, const
              real_T in13[11], real_T *eval, real_T deval[132]);

/* End of code generation (autoEval.h) */
