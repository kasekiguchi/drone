/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * F_HL_MPCfunc_data.h
 *
 * Code generation for function 'F_HL_MPCfunc_data'
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

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;
extern emlrtRSInfo d_emlrtRSI;
extern emlrtRSInfo o_emlrtRSI;
extern emlrtRSInfo p_emlrtRSI;
extern emlrtRSInfo q_emlrtRSI;
extern emlrtRSInfo r_emlrtRSI;
extern emlrtRSInfo s_emlrtRSI;
extern emlrtRSInfo t_emlrtRSI;
extern emlrtRSInfo eb_emlrtRSI;
extern emlrtRSInfo fb_emlrtRSI;
extern emlrtRSInfo gb_emlrtRSI;
extern emlrtRSInfo hb_emlrtRSI;
extern emlrtRSInfo ib_emlrtRSI;
extern emlrtRSInfo jb_emlrtRSI;
extern emlrtRSInfo kb_emlrtRSI;
extern emlrtRSInfo lb_emlrtRSI;
extern emlrtRSInfo mb_emlrtRSI;
extern emlrtRSInfo nb_emlrtRSI;
extern emlrtRSInfo ob_emlrtRSI;
extern emlrtRSInfo pb_emlrtRSI;
extern emlrtRSInfo qb_emlrtRSI;
extern emlrtRSInfo rb_emlrtRSI;
extern emlrtRSInfo sb_emlrtRSI;
extern emlrtRSInfo tb_emlrtRSI;
extern emlrtRSInfo ub_emlrtRSI;
extern emlrtRSInfo vb_emlrtRSI;
extern emlrtRSInfo wb_emlrtRSI;
extern emlrtRSInfo xb_emlrtRSI;
extern emlrtRSInfo yb_emlrtRSI;
extern emlrtRSInfo ac_emlrtRSI;
extern emlrtRSInfo bc_emlrtRSI;
extern emlrtRSInfo cc_emlrtRSI;
extern emlrtRSInfo dc_emlrtRSI;
extern emlrtRSInfo ec_emlrtRSI;
extern emlrtRSInfo fc_emlrtRSI;
extern emlrtRSInfo gc_emlrtRSI;
extern emlrtRSInfo hc_emlrtRSI;
extern emlrtRSInfo ic_emlrtRSI;
extern emlrtRSInfo jc_emlrtRSI;
extern emlrtRSInfo kc_emlrtRSI;
extern emlrtRSInfo lc_emlrtRSI;
extern emlrtRSInfo mc_emlrtRSI;
extern emlrtRSInfo nc_emlrtRSI;
extern emlrtRSInfo oc_emlrtRSI;
extern emlrtRSInfo pc_emlrtRSI;
extern emlrtRSInfo qc_emlrtRSI;
extern emlrtRSInfo rc_emlrtRSI;
extern emlrtRSInfo sc_emlrtRSI;
extern emlrtRSInfo od_emlrtRSI;
extern emlrtRSInfo pd_emlrtRSI;
extern emlrtRSInfo qd_emlrtRSI;
extern emlrtRSInfo rd_emlrtRSI;
extern emlrtRSInfo sd_emlrtRSI;
extern emlrtRSInfo td_emlrtRSI;
extern emlrtRSInfo ud_emlrtRSI;
extern emlrtRSInfo vd_emlrtRSI;
extern emlrtRSInfo wd_emlrtRSI;
extern emlrtRSInfo xd_emlrtRSI;
extern emlrtRSInfo yd_emlrtRSI;
extern emlrtRSInfo fe_emlrtRSI;
extern emlrtRSInfo ke_emlrtRSI;
extern emlrtRSInfo re_emlrtRSI;
extern emlrtRSInfo we_emlrtRSI;
extern emlrtRSInfo xe_emlrtRSI;
extern emlrtRSInfo ye_emlrtRSI;
extern emlrtRSInfo ff_emlrtRSI;
extern emlrtRSInfo of_emlrtRSI;
extern emlrtRSInfo pf_emlrtRSI;
extern emlrtRSInfo rf_emlrtRSI;
extern emlrtRSInfo fg_emlrtRSI;
extern emlrtRSInfo gg_emlrtRSI;
extern emlrtRSInfo hg_emlrtRSI;
extern emlrtRSInfo kg_emlrtRSI;
extern emlrtRSInfo lg_emlrtRSI;
extern emlrtRSInfo og_emlrtRSI;
extern emlrtRSInfo pg_emlrtRSI;
extern emlrtRSInfo qg_emlrtRSI;
extern emlrtRSInfo rg_emlrtRSI;
extern emlrtRSInfo ug_emlrtRSI;
extern emlrtRSInfo xg_emlrtRSI;
extern emlrtRSInfo yg_emlrtRSI;
extern emlrtRSInfo ch_emlrtRSI;
extern emlrtRSInfo gh_emlrtRSI;
extern emlrtRSInfo hh_emlrtRSI;
extern emlrtRSInfo mh_emlrtRSI;
extern emlrtRSInfo ph_emlrtRSI;
extern emlrtRSInfo ai_emlrtRSI;
extern emlrtRSInfo bi_emlrtRSI;
extern emlrtRSInfo ci_emlrtRSI;
extern emlrtRSInfo di_emlrtRSI;
extern emlrtRSInfo mi_emlrtRSI;
extern emlrtRSInfo ti_emlrtRSI;
extern emlrtRSInfo vi_emlrtRSI;
extern emlrtRSInfo dj_emlrtRSI;
extern emlrtRSInfo ej_emlrtRSI;
extern emlrtRSInfo hj_emlrtRSI;
extern emlrtRSInfo jj_emlrtRSI;
extern emlrtRSInfo kj_emlrtRSI;
extern emlrtRSInfo lj_emlrtRSI;
extern emlrtRSInfo mj_emlrtRSI;
extern emlrtRSInfo oj_emlrtRSI;
extern emlrtRSInfo uj_emlrtRSI;
extern emlrtRSInfo vj_emlrtRSI;
extern emlrtRSInfo xj_emlrtRSI;
extern emlrtRSInfo dk_emlrtRSI;
extern emlrtRSInfo pk_emlrtRSI;
extern emlrtRSInfo qk_emlrtRSI;
extern emlrtRSInfo sk_emlrtRSI;
extern emlrtBCInfo c_emlrtBCI;
extern emlrtBCInfo d_emlrtBCI;
extern emlrtRTEInfo f_emlrtRTEI;
extern emlrtRTEInfo j_emlrtRTEI;
extern emlrtRTEInfo k_emlrtRTEI;
extern emlrtBCInfo cc_emlrtBCI;
extern emlrtBCInfo ic_emlrtBCI;
extern emlrtBCInfo kc_emlrtBCI;
extern emlrtBCInfo mc_emlrtBCI;
extern emlrtBCInfo bd_emlrtBCI;
extern emlrtBCInfo cd_emlrtBCI;
extern emlrtBCInfo jd_emlrtBCI;
extern emlrtBCInfo od_emlrtBCI;
extern emlrtBCInfo qd_emlrtBCI;
extern emlrtBCInfo rd_emlrtBCI;
extern emlrtRTEInfo l_emlrtRTEI;
extern emlrtRTEInfo v_emlrtRTEI;

/* End of code generation (F_HL_MPCfunc_data.h) */
