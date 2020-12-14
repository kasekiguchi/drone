/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * F_HL_MPCfunc_data.c
 *
 * Code generation for function 'F_HL_MPCfunc_data'
 *
 */

/* Include files */
#include "F_HL_MPCfunc_data.h"
#include "F_HL_MPCfunc.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131594U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "F_HL_MPCfunc",                      /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2666790369U, 2630951428U, 3350295197U, 1643587045U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

emlrtRSInfo d_emlrtRSI = { 39,         /* lineNo */
  "function_handle/parenReference",    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\function_handle.m"/* pathName */
};

emlrtRSInfo o_emlrtRSI = { 29,         /* lineNo */
  "outputScalarEg",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\outputScalarEg.m"/* pathName */
};

emlrtRSInfo p_emlrtRSI = { 40,         /* lineNo */
  "arrayfun",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datatypes\\arrayfun.m"/* pathName */
};

emlrtRSInfo q_emlrtRSI = { 49,         /* lineNo */
  "applyArrayFunction",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datatypes\\arrayfun.m"/* pathName */
};

emlrtRSInfo r_emlrtRSI = { 63,         /* lineNo */
  "applyArrayFunction",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datatypes\\arrayfun.m"/* pathName */
};

emlrtRSInfo s_emlrtRSI = { 69,         /* lineNo */
  "applyArrayFunction",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datatypes\\arrayfun.m"/* pathName */
};

emlrtRSInfo t_emlrtRSI = { 21,         /* lineNo */
  "eml_int_forloop_overflow_check",    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\eml\\eml_int_forloop_overflow_check.m"/* pathName */
};

emlrtRSInfo eb_emlrtRSI = { 754,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo fb_emlrtRSI = { 755,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo gb_emlrtRSI = { 756,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo hb_emlrtRSI = { 757,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo ib_emlrtRSI = { 758,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo jb_emlrtRSI = { 759,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo kb_emlrtRSI = { 760,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo lb_emlrtRSI = { 761,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo mb_emlrtRSI = { 762,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo nb_emlrtRSI = { 763,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo ob_emlrtRSI = { 764,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo pb_emlrtRSI = { 765,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo qb_emlrtRSI = { 766,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo rb_emlrtRSI = { 767,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo sb_emlrtRSI = { 768,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo tb_emlrtRSI = { 769,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo ub_emlrtRSI = { 770,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo vb_emlrtRSI = { 771,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo wb_emlrtRSI = { 772,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo xb_emlrtRSI = { 773,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo yb_emlrtRSI = { 774,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo ac_emlrtRSI = { 775,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo bc_emlrtRSI = { 776,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo cc_emlrtRSI = { 777,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo dc_emlrtRSI = { 778,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo ec_emlrtRSI = { 779,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo fc_emlrtRSI = { 780,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo gc_emlrtRSI = { 781,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo hc_emlrtRSI = { 782,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo ic_emlrtRSI = { 783,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo jc_emlrtRSI = { 784,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo kc_emlrtRSI = { 785,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo lc_emlrtRSI = { 786,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo mc_emlrtRSI = { 787,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo nc_emlrtRSI = { 788,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo oc_emlrtRSI = { 789,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo pc_emlrtRSI = { 790,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo qc_emlrtRSI = { 791,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo rc_emlrtRSI = { 792,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo sc_emlrtRSI = { 793,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo od_emlrtRSI = { 874,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo pd_emlrtRSI = { 875,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo qd_emlrtRSI = { 876,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo rd_emlrtRSI = { 877,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo sd_emlrtRSI = { 878,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo td_emlrtRSI = { 879,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo ud_emlrtRSI = { 880,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo vd_emlrtRSI = { 881,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo wd_emlrtRSI = { 882,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo xd_emlrtRSI = { 883,       /* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

emlrtRSInfo yd_emlrtRSI = { 70,        /* lineNo */
  "power",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\power.m"/* pathName */
};

emlrtRSInfo fe_emlrtRSI = { 69,        /* lineNo */
  "objective",                         /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

emlrtRSInfo ke_emlrtRSI = { 45,        /* lineNo */
  "mpower",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\mpower.m"/* pathName */
};

emlrtRSInfo re_emlrtRSI = { 186,       /* lineNo */
  "autoEval",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoEval.m"/* pathName */
};

emlrtRSInfo we_emlrtRSI = { 1,         /* lineNo */
  "updateWorkingSetForNewQP",          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+internal\\updateWorkingSetForNewQP.p"/* pathName */
};

emlrtRSInfo xe_emlrtRSI = { 38,        /* lineNo */
  "xcopy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xcopy.m"/* pathName */
};

emlrtRSInfo ye_emlrtRSI = { 69,        /* lineNo */
  "xcopy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xcopy.m"/* pathName */
};

emlrtRSInfo ff_emlrtRSI = { 1,         /* lineNo */
  "test_exit",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\test_exit.p"/* pathName */
};

emlrtRSInfo of_emlrtRSI = { 51,        /* lineNo */
  "xcopy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xcopy.m"/* pathName */
};

emlrtRSInfo pf_emlrtRSI = { 50,        /* lineNo */
  "xcopy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xcopy.m"/* pathName */
};

emlrtRSInfo rf_emlrtRSI = { 1,         /* lineNo */
  "factorQRE",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\factorQRE.p"/* pathName */
};

emlrtRSInfo fg_emlrtRSI = { 9,         /* lineNo */
  "int",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\int.m"/* pathName */
};

emlrtRSInfo gg_emlrtRSI = { 8,         /* lineNo */
  "majority",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\majority.m"/* pathName */
};

emlrtRSInfo hg_emlrtRSI = { 31,        /* lineNo */
  "infocheck",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\infocheck.m"/* pathName */
};

emlrtRSInfo kg_emlrtRSI = { 31,        /* lineNo */
  "xscal",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xscal.m"/* pathName */
};

emlrtRSInfo lg_emlrtRSI = { 18,        /* lineNo */
  "xscal",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xscal.m"/* pathName */
};

emlrtRSInfo og_emlrtRSI = { 33,        /* lineNo */
  "ixamax",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\ixamax.m"/* pathName */
};

emlrtRSInfo pg_emlrtRSI = { 38,        /* lineNo */
  "ceval_xorgqr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xorgqr.m"/* pathName */
};

emlrtRSInfo qg_emlrtRSI = { 46,        /* lineNo */
  "ceval_xorgqr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xorgqr.m"/* pathName */
};

emlrtRSInfo rg_emlrtRSI = { 51,        /* lineNo */
  "ceval_xorgqr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xorgqr.m"/* pathName */
};

emlrtRSInfo ug_emlrtRSI = { 1,         /* lineNo */
  "computeSquareQ",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\computeSquareQ.p"/* pathName */
};

emlrtRSInfo xg_emlrtRSI = { 71,        /* lineNo */
  "xtrsv",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xtrsv.m"/* pathName */
};

emlrtRSInfo yg_emlrtRSI = { 70,        /* lineNo */
  "xtrsv",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xtrsv.m"/* pathName */
};

emlrtRSInfo ch_emlrtRSI = { 1,         /* lineNo */
  "saveState",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+TrialState\\saveState.p"/* pathName */
};

emlrtRSInfo gh_emlrtRSI = { 49,        /* lineNo */
  "xdot",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xdot.m"/* pathName */
};

emlrtRSInfo hh_emlrtRSI = { 15,        /* lineNo */
  "xdot",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xdot.m"/* pathName */
};

emlrtRSInfo mh_emlrtRSI = { 1,         /* lineNo */
  "removeConstr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p"/* pathName */
};

emlrtRSInfo ph_emlrtRSI = { 1,         /* lineNo */
  "factorQR",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\factorQR.p"/* pathName */
};

emlrtRSInfo ai_emlrtRSI = { 88,        /* lineNo */
  "xgemm",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xgemm.m"/* pathName */
};

emlrtRSInfo bi_emlrtRSI = { 86,        /* lineNo */
  "xgemm",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xgemm.m"/* pathName */
};

emlrtRSInfo ci_emlrtRSI = { 77,        /* lineNo */
  "xtrsm",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xtrsm.m"/* pathName */
};

emlrtRSInfo di_emlrtRSI = { 76,        /* lineNo */
  "xtrsm",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xtrsm.m"/* pathName */
};

emlrtRSInfo mi_emlrtRSI = { 1,         /* lineNo */
  "maxConstraintViolation",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation.p"/* pathName */
};

emlrtRSInfo ti_emlrtRSI = { 35,        /* lineNo */
  "xdot",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xdot.m"/* pathName */
};

emlrtRSInfo vi_emlrtRSI = { 1,         /* lineNo */
  "linearFormReg_",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\linearFormReg_.p"/* pathName */
};

emlrtRSInfo dj_emlrtRSI = { 48,        /* lineNo */
  "xrot",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xrot.m"/* pathName */
};

emlrtRSInfo ej_emlrtRSI = { 47,        /* lineNo */
  "xrot",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xrot.m"/* pathName */
};

emlrtRSInfo hj_emlrtRSI = { 1,         /* lineNo */
  "factor",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+CholManager\\factor.p"/* pathName */
};

emlrtRSInfo jj_emlrtRSI = { 73,        /* lineNo */
  "ceval_xpotrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xpotrf.m"/* pathName */
};

emlrtRSInfo kj_emlrtRSI = { 70,        /* lineNo */
  "ceval_xpotrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xpotrf.m"/* pathName */
};

emlrtRSInfo lj_emlrtRSI = { 37,        /* lineNo */
  "ceval_xpotrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xpotrf.m"/* pathName */
};

emlrtRSInfo mj_emlrtRSI = { 36,        /* lineNo */
  "ceval_xpotrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xpotrf.m"/* pathName */
};

emlrtRSInfo oj_emlrtRSI = { 1,         /* lineNo */
  "solve",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+CholManager\\solve.p"/* pathName */
};

emlrtRSInfo uj_emlrtRSI = { 1,         /* lineNo */
  "addAineqConstr",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAineqConstr.p"/* pathName */
};

emlrtRSInfo vj_emlrtRSI = { 1,         /* lineNo */
  "addLBConstr",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addLBConstr.p"/* pathName */
};

emlrtRSInfo xj_emlrtRSI = { 1,         /* lineNo */
  "addUBConstr",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addUBConstr.p"/* pathName */
};

emlrtRSInfo dk_emlrtRSI = { 23,        /* lineNo */
  "xasum",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xasum.m"/* pathName */
};

emlrtRSInfo pk_emlrtRSI = { 1,         /* lineNo */
  "evalObjAndConstr",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\evalObjAndConstr.p"/* pathName */
};

emlrtRSInfo qk_emlrtRSI = { 1,         /* lineNo */
  "computeMeritFcn",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\computeMeritFcn.p"/* pathName */
};

emlrtRSInfo sk_emlrtRSI = { 1,         /* lineNo */
  "revertSolution",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+TrialState\\revertSolution.p"/* pathName */
};

emlrtBCInfo c_emlrtBCI = { 1,          /* iFirst */
  299245,                              /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSetForNewQP",          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+internal\\updateWorkingSetForNewQP.p",/* pName */
  3                                    /* checkKind */
};

emlrtBCInfo d_emlrtBCI = { 1,          /* iFirst */
  42680,                               /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSetForNewQP",          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+internal\\updateWorkingSetForNewQP.p",/* pName */
  0                                    /* checkKind */
};

emlrtRTEInfo f_emlrtRTEI = { 46,       /* lineNo */
  23,                                  /* colNo */
  "sumprod",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\sumprod.m"/* pName */
};

emlrtRTEInfo j_emlrtRTEI = { 48,       /* lineNo */
  13,                                  /* colNo */
  "infocheck",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\infocheck.m"/* pName */
};

emlrtRTEInfo k_emlrtRTEI = { 45,       /* lineNo */
  13,                                  /* colNo */
  "infocheck",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\infocheck.m"/* pName */
};

emlrtBCInfo cc_emlrtBCI = { 1,         /* iFirst */
  6,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo ic_emlrtBCI = { 1,         /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo kc_emlrtBCI = { 1,         /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p",/* pName */
  3                                    /* checkKind */
};

emlrtBCInfo mc_emlrtBCI = { 1,         /* iFirst */
  5,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeConstr.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo bd_emlrtBCI = { 1,         /* iFirst */
  485,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "maxConstraintViolation",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo cd_emlrtBCI = { 1,         /* iFirst */
  299245,                              /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "maxConstraintViolation",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo jd_emlrtBCI = { 1,         /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "isActive",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\isActive.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo od_emlrtBCI = { 1,         /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addConstrUpdateRecords_",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addConstrUpdateRecords_.p",/* pName */
  3                                    /* checkKind */
};

emlrtBCInfo qd_emlrtBCI = { 1,         /* iFirst */
  176,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAineqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAineqConstr.p",/* pName */
  0                                    /* checkKind */
};

emlrtBCInfo rd_emlrtBCI = { 1,         /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAineqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAineqConstr.p",/* pName */
  3                                    /* checkKind */
};

emlrtRTEInfo l_emlrtRTEI = { 28,       /* lineNo */
  9,                                   /* colNo */
  "colon",                             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pName */
};

emlrtRTEInfo v_emlrtRTEI = { 40,       /* lineNo */
  23,                                  /* colNo */
  "arrayfun",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datatypes\\arrayfun.m"/* pName */
};

/* End of code generation (F_HL_MPCfunc_data.c) */
