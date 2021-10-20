/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fminconMEX_Trackobjective_data.c
 *
 * Code generation for function 'fminconMEX_Trackobjective_data'
 *
 */

/* Include files */
#include "fminconMEX_Trackobjective_data.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
const volatile char_T *emlrtBreakCheckR2012bFlagVar = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131595U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "fminconMEX_Trackobjective",         /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2666790369U, 2630951428U, 3350295197U, 1643587045U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

emlrtRSInfo e_emlrtRSI = { 47,         /* lineNo */
  "function_handle/parenReference",    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\function_handle.m"/* pathName */
};

emlrtRSInfo s_emlrtRSI = { 21,         /* lineNo */
  "eml_int_forloop_overflow_check",    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\eml\\eml_int_forloop_overflow_check.m"/* pathName */
};

emlrtRSInfo eb_emlrtRSI = { 1,         /* lineNo */
  "updateWorkingSetForNewQP",          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+internal\\updateWorkingSetForNewQP.p"/* pathName */
};

emlrtRSInfo gb_emlrtRSI = { 69,        /* lineNo */
  "xcopy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xcopy.m"/* pathName */
};

emlrtRSInfo xb_emlrtRSI = { 38,        /* lineNo */
  "xcopy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xcopy.m"/* pathName */
};

emlrtRSInfo ac_emlrtRSI = { 1,         /* lineNo */
  "factorQRE",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+QRManager\\factorQRE.p"/* pathName */
};

emlrtRSInfo oc_emlrtRSI = { 1,         /* lineNo */
  "computeSquareQ",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+QRManager\\computeSquareQ.p"/* pathName */
};

emlrtRSInfo id_emlrtRSI = { 1,         /* lineNo */
  "removeConstr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p"/* pathName */
};

emlrtRSInfo md_emlrtRSI = { 1,         /* lineNo */
  "factorQR",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+QRManager\\factorQR.p"/* pathName */
};

emlrtRSInfo be_emlrtRSI = { 1,         /* lineNo */
  "maxConstraintViolation",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation.p"/* pathName */
};

emlrtRSInfo ce_emlrtRSI = { 1,         /* lineNo */
  "maxConstraintViolation_AMats_regularized_",/* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation_AMats_regularized_.p"/* pathName */
};

emlrtRSInfo de_emlrtRSI = { 1,         /* lineNo */
  "maxConstraintViolation_AMats_nonregularized_",/* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation_AMats_nonregularized_"
  ".p"                                 /* pathName */
};

emlrtRSInfo te_emlrtRSI = { 1,         /* lineNo */
  "factor",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+CholManager\\factor.p"/* pathName */
};

emlrtRSInfo df_emlrtRSI = { 1,         /* lineNo */
  "addAineqConstr",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAineqConstr.p"/* pathName */
};

emlrtRSInfo ef_emlrtRSI = { 1,         /* lineNo */
  "addLBConstr",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addLBConstr.p"/* pathName */
};

emlrtRSInfo gf_emlrtRSI = { 1,         /* lineNo */
  "addUBConstr",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addUBConstr.p"/* pathName */
};

emlrtRSInfo tf_emlrtRSI = { 1,         /* lineNo */
  "evalObjAndConstr",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\evalObjAndConstr.p"/* pathName */
};

emlrtBCInfo emlrtBCI = { -1,           /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSetForNewQP",          /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+internal\\updateWorkingSetForNewQP.p",/* pName */
  0                                    /* checkKind */
};

emlrtRTEInfo o_emlrtRTEI = { 47,       /* lineNo */
  13,                                  /* colNo */
  "infocheck",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\infocheck.m"/* pName */
};

emlrtRTEInfo p_emlrtRTEI = { 44,       /* lineNo */
  13,                                  /* colNo */
  "infocheck",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\infocheck.m"/* pName */
};

emlrtBCInfo tb_emlrtBCI = { -1,        /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "isActive",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\isActive.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo ub_emlrtBCI = { -1,        /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo vb_emlrtBCI = { 1,         /* iFirst */
  6,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo xb_emlrtBCI = { 1,         /* iFirst */
  5,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo ic_emlrtBCI = { -1,        /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "maxConstraintViolation",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo jc_emlrtBCI = { -1,        /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "maxConstraintViolation_AMats_nonregularized_",/* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation_AMats_nonregularized_"
  ".p",                                /* pName */
  0                                    /* checkKind */
};

emlrtBCInfo kc_emlrtBCI = { -1,        /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "maxConstraintViolation_AMats_regularized_",/* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation_AMats_regularized_.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo mc_emlrtBCI = { -1,        /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "factorQR",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+QRManager\\factorQR.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo tc_emlrtBCI = { -1,        /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addConstrUpdateRecords_",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addConstrUpdateRecords_.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo uc_emlrtBCI = { -1,        /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAineqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAineqConstr.p",/* pName */
  0                                    /* checkKind */
};

/* End of code generation (fminconMEX_Trackobjective_data.c) */
