/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * solve.h
 *
 * Code generation for function 'solve'
 *
 */

#pragma once

/* Include files */
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void b_solve(const h_struct_T *obj, emxArray_real_T *rhs);
void solve(const h_struct_T *obj, emxArray_real_T *rhs);

/* End of code generation (solve.h) */
