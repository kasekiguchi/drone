/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * L_HL_MPCfunc_data.c
 *
 * Code generation for function 'L_HL_MPCfunc_data'
 *
 */

/* Include files */
#include "L_HL_MPCfunc_data.h"
#include "L_HL_MPCfunc.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131594U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "L_HL_MPCfunc",                      /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2666790369U, 2630951428U, 3350295197U, 1643587045U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

emlrtRSInfo e_emlrtRSI = { 21,         /* lineNo */
  "eml_int_forloop_overflow_check",    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\eml\\eml_int_forloop_overflow_check.m"/* pathName */
};

emlrtRSInfo f_emlrtRSI = { 1,          /* lineNo */
  "computeFiniteDifferences",          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\computeFiniteDifferences.p"/* pathName */
};

emlrtRSInfo g_emlrtRSI = { 1,          /* lineNo */
  "computeForwardDifferences",         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\+internal\\computeForwardDifferences.p"/* pathName */
};

emlrtRSInfo h_emlrtRSI = { 1,          /* lineNo */
  "updateWorkingSetForNewQP",          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+internal\\updateWorkingSetForNewQP.p"/* pathName */
};

emlrtRSInfo i_emlrtRSI = { 38,         /* lineNo */
  "xcopy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xcopy.m"/* pathName */
};

emlrtRSInfo j_emlrtRSI = { 69,         /* lineNo */
  "xcopy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xcopy.m"/* pathName */
};

emlrtRSInfo p_emlrtRSI = { 1,          /* lineNo */
  "test_exit",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\test_exit.p"/* pathName */
};

emlrtRSInfo t_emlrtRSI = { 23,         /* lineNo */
  "ixamax",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\ixamax.m"/* pathName */
};

emlrtRSInfo u_emlrtRSI = { 24,         /* lineNo */
  "ixamax",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\ixamax.m"/* pathName */
};

emlrtRSInfo ab_emlrtRSI = { 1,         /* lineNo */
  "factorQRE",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\factorQRE.p"/* pathName */
};

emlrtRSInfo nb_emlrtRSI = { 9,         /* lineNo */
  "int",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\int.m"/* pathName */
};

emlrtRSInfo ob_emlrtRSI = { 8,         /* lineNo */
  "majority",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\majority.m"/* pathName */
};

emlrtRSInfo pb_emlrtRSI = { 31,        /* lineNo */
  "infocheck",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\infocheck.m"/* pathName */
};

emlrtRSInfo sb_emlrtRSI = { 31,        /* lineNo */
  "xscal",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xscal.m"/* pathName */
};

emlrtRSInfo tb_emlrtRSI = { 18,        /* lineNo */
  "xscal",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xscal.m"/* pathName */
};

emlrtRSInfo ac_emlrtRSI = { 38,        /* lineNo */
  "ceval_xorgqr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xorgqr.m"/* pathName */
};

emlrtRSInfo bc_emlrtRSI = { 46,        /* lineNo */
  "ceval_xorgqr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xorgqr.m"/* pathName */
};

emlrtRSInfo cc_emlrtRSI = { 51,        /* lineNo */
  "ceval_xorgqr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xorgqr.m"/* pathName */
};

emlrtRSInfo fc_emlrtRSI = { 1,         /* lineNo */
  "computeSquareQ",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\computeSquareQ.p"/* pathName */
};

emlrtRSInfo ic_emlrtRSI = { 71,        /* lineNo */
  "xtrsv",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xtrsv.m"/* pathName */
};

emlrtRSInfo jc_emlrtRSI = { 70,        /* lineNo */
  "xtrsv",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xtrsv.m"/* pathName */
};

emlrtRSInfo mc_emlrtRSI = { 1,         /* lineNo */
  "saveState",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+TrialState\\saveState.p"/* pathName */
};

emlrtRSInfo qc_emlrtRSI = { 35,        /* lineNo */
  "xdot",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xdot.m"/* pathName */
};

emlrtRSInfo rc_emlrtRSI = { 15,        /* lineNo */
  "xdot",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xdot.m"/* pathName */
};

emlrtRSInfo wc_emlrtRSI = { 1,         /* lineNo */
  "removeConstr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p"/* pathName */
};

emlrtRSInfo ad_emlrtRSI = { 1,         /* lineNo */
  "factorQR",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\factorQR.p"/* pathName */
};

emlrtRSInfo kd_emlrtRSI = { 88,        /* lineNo */
  "xgemm",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xgemm.m"/* pathName */
};

emlrtRSInfo ld_emlrtRSI = { 86,        /* lineNo */
  "xgemm",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xgemm.m"/* pathName */
};

emlrtRSInfo md_emlrtRSI = { 77,        /* lineNo */
  "xtrsm",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xtrsm.m"/* pathName */
};

emlrtRSInfo nd_emlrtRSI = { 76,        /* lineNo */
  "xtrsm",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xtrsm.m"/* pathName */
};

emlrtRSInfo wd_emlrtRSI = { 1,         /* lineNo */
  "maxConstraintViolation",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation.p"/* pathName */
};

emlrtRSInfo fe_emlrtRSI = { 1,         /* lineNo */
  "linearFormReg_",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\linearFormReg_.p"/* pathName */
};

emlrtRSInfo qe_emlrtRSI = { 1,         /* lineNo */
  "factor",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+CholManager\\factor.p"/* pathName */
};

emlrtRSInfo se_emlrtRSI = { 73,        /* lineNo */
  "ceval_xpotrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xpotrf.m"/* pathName */
};

emlrtRSInfo te_emlrtRSI = { 70,        /* lineNo */
  "ceval_xpotrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xpotrf.m"/* pathName */
};

emlrtRSInfo ue_emlrtRSI = { 37,        /* lineNo */
  "ceval_xpotrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xpotrf.m"/* pathName */
};

emlrtRSInfo ve_emlrtRSI = { 36,        /* lineNo */
  "ceval_xpotrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xpotrf.m"/* pathName */
};

emlrtRSInfo xe_emlrtRSI = { 1,         /* lineNo */
  "solve",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+CholManager\\solve.p"/* pathName */
};

emlrtRSInfo ef_emlrtRSI = { 1,         /* lineNo */
  "addAineqConstr",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAineqConstr.p"/* pathName */
};

emlrtRSInfo ff_emlrtRSI = { 1,         /* lineNo */
  "addLBConstr",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addLBConstr.p"/* pathName */
};

emlrtRSInfo hf_emlrtRSI = { 1,         /* lineNo */
  "addUBConstr",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addUBConstr.p"/* pathName */
};

emlrtRSInfo mf_emlrtRSI = { 23,        /* lineNo */
  "xasum",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xasum.m"/* pathName */
};

emlrtRSInfo yf_emlrtRSI = { 1,         /* lineNo */
  "evalObjAndConstr",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\evalObjAndConstr.p"/* pathName */
};

emlrtRSInfo ag_emlrtRSI = { 1,         /* lineNo */
  "computeMeritFcn",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\computeMeritFcn.p"/* pathName */
};

emlrtRSInfo cg_emlrtRSI = { 1,         /* lineNo */
  "revertSolution",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+TrialState\\revertSolution.p"/* pathName */
};

emlrtBCInfo c_emlrtBCI = { 1,          /* iFirst */
  93635,                               /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSetForNewQP",          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+internal\\updateWorkingSetForNewQP.p",/* pName */
  3                                    /* checkKind */
};

emlrtBCInfo d_emlrtBCI = { 1,          /* iFirst */
  27016,                               /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSetForNewQP",          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+internal\\updateWorkingSetForNewQP.p",/* pName */
  0                                    /* checkKind */
};

emlrtRTEInfo d_emlrtRTEI = { 48,       /* lineNo */
  13,                                  /* colNo */
  "infocheck",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\infocheck.m"/* pName */
};

emlrtRTEInfo e_emlrtRTEI = { 45,       /* lineNo */
  13,                                  /* colNo */
  "infocheck",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\infocheck.m"/* pName */
};

emlrtBCInfo eb_emlrtBCI = { 1,         /* iFirst */
  6,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo nb_emlrtBCI = { 1,         /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo pb_emlrtBCI = { 1,         /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p",/* pName */
  3                                    /* checkKind */
};

emlrtBCInfo rb_emlrtBCI = { 1,         /* iFirst */
  5,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo ec_emlrtBCI = { 1,         /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "maxConstraintViolation",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo fc_emlrtBCI = { 1,         /* iFirst */
  94249,                               /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "maxConstraintViolation",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo mc_emlrtBCI = { 1,         /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "isActive",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\isActive.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo rc_emlrtBCI = { 1,         /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addConstrUpdateRecords_",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addConstrUpdateRecords_.p",/* pName */
  3                                    /* checkKind */
};

emlrtBCInfo tc_emlrtBCI = { 1,         /* iFirst */
  20,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAineqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAineqConstr.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo uc_emlrtBCI = { 1,         /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAineqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAineqConstr.p",/* pName */
  3                                    /* checkKind */
};

/* End of code generation (L_HL_MPCfunc_data.c) */
