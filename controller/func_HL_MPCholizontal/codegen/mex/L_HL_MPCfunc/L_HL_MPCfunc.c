/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * L_HL_MPCfunc.c
 *
 * Code generation for function 'L_HL_MPCfunc'
 *
 */

/* Include files */
#include "L_HL_MPCfunc.h"
#include "fmincon.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 33,    /* lineNo */
  "L_HL_MPCfunc",                      /* fcnName */
  "C:\\\\Users\\\\taku7\\\\Desktop\\\\\xe6\x9c\x1a\xe6\x96\xb0\x64rone\\\\controller\\\\func_HL_MPCholizontal\\\\L_HL_MPCfunc.m"/* pathName */
};

/* Function Definitions */
void L_HL_MPCfunc(L_HL_MPCfuncStackData *SD, const emlrtStack *sp, const
                  struct0_T *MPCparam, const struct1_T *linear_model, const
                  real_T MPCprevious_variables[110], real_T funcresult[110])
{
  struct0_T objective_tunableEnvironment[1];
  real_T nonlcon_tunableEnvironment_f1_Q[64];
  real_T b_nonlcon_tunableEnvironment_f1[64];
  real_T nonlcon_tunableEnvironment_f1_R[4];
  real_T c_nonlcon_tunableEnvironment_f1[88];
  real_T d_nonlcon_tunableEnvironment_f1[8];
  real_T nonlcon_tunableEnvironment_f2_A[64];
  real_T nonlcon_tunableEnvironment_f2_B[16];
  real_T unusedU0;
  real_T unusedU1;
  real_T expl_temp;
  real_T b_expl_temp;
  char_T c_expl_temp[3];
  real_T d_expl_temp;
  real_T e_expl_temp;
  real_T f_expl_temp;
  real_T g_expl_temp;
  d_struct_T unusedU3;
  real_T unusedU4[110];
  real_T unusedU5[12100];
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;

  /* 高速化のため，do controllerの中のfminconの部分のみ関数化 */
  /*    */
  /* MPC */
  /* options_setting */
  /*              options.UseParallel            = false; */
  /*  options.Display                = 'none'; */
  /*  評価関数の最大値 */
  /*  最大反復回数 */
  /*  options.StepTolerance          = optimoptions(options,'StepTolerance',1.e-12);%xに関する終了許容誤差 */
  /* 制約違反に対する許容誤差 */
  /*  options    = optimoptions(options,'OptimalityTolerance',1.e-12);%1 次の最適性に関する終了許容誤差。 */
  /*  options                = optimoptions(options,'PlotFcn',[]); */
  /*  SQPアルゴリズムの指定      これが一番最後にいないとcodegen時にエラーが吐かれる */
  /*              problem.objective = @(x) Lobjective(x, obj.param);  % 評価関数 */
  /*              problem.nonlcon   = @(x) constraints(x, obj.param);% 制約条件 */
  objective_tunableEnvironment[0] = *MPCparam;

  /*  評価関数 */
  memcpy(&nonlcon_tunableEnvironment_f1_Q[0], &MPCparam->Q[0], 64U * sizeof
         (real_T));
  memcpy(&b_nonlcon_tunableEnvironment_f1[0], &MPCparam->Qf[0], 64U * sizeof
         (real_T));
  nonlcon_tunableEnvironment_f1_R[0] = MPCparam->R[0];
  nonlcon_tunableEnvironment_f1_R[1] = MPCparam->R[1];
  nonlcon_tunableEnvironment_f1_R[2] = MPCparam->R[2];
  nonlcon_tunableEnvironment_f1_R[3] = MPCparam->R[3];
  memcpy(&c_nonlcon_tunableEnvironment_f1[0], &MPCparam->Xr[0], 88U * sizeof
         (real_T));
  memcpy(&d_nonlcon_tunableEnvironment_f1[0], &MPCparam->X0[0], 8U * sizeof
         (real_T));
  memcpy(&nonlcon_tunableEnvironment_f2_A[0], &linear_model->A[0], 64U * sizeof
         (real_T));
  memcpy(&nonlcon_tunableEnvironment_f2_B[0], &linear_model->B[0], 16U * sizeof
         (real_T));

  /*  制約条件 */
  /*      problem.x0		  = [previous_vurtualstate;previous_input{N}]; % 初期状態 */
  /* [var, fval, exitflag, output, lambda, grad, hessian] = fmincon(problem); */
  st.site = &emlrtRSI;
  fmincon(SD, &st, objective_tunableEnvironment, MPCprevious_variables,
          nonlcon_tunableEnvironment_f1_Q, b_nonlcon_tunableEnvironment_f1,
          nonlcon_tunableEnvironment_f1_R, c_nonlcon_tunableEnvironment_f1,
          d_nonlcon_tunableEnvironment_f1, MPCparam->Slew,
          nonlcon_tunableEnvironment_f2_A, nonlcon_tunableEnvironment_f2_B,
          funcresult, &unusedU0, &unusedU1, &expl_temp, &b_expl_temp,
          c_expl_temp, &d_expl_temp, &e_expl_temp, &f_expl_temp, &g_expl_temp,
          &unusedU3, unusedU4, unusedU5);

  /*              obj.previous_variables = var; */
  /*              disp(exitflag); */
}

real_T __anon_fcn(const real_T MPCparam_Q[64], const real_T MPCparam_Qf[64],
                  const real_T MPCparam_R[4], const real_T MPCparam_Xr[88],
                  const real_T x[110])
{
  real_T t110;
  real_T t111;
  real_T t112;
  real_T t113;
  real_T t114;
  real_T t115;
  real_T t116;
  real_T t117;
  real_T t118;
  real_T t119;
  real_T t120;
  real_T t121;
  real_T t122;
  real_T t123;
  real_T t124;
  real_T t125;
  real_T t126;
  real_T t127;
  real_T t128;
  real_T t129;
  real_T t130;
  real_T t131;
  real_T t132;
  real_T t133;
  real_T t134;
  real_T t135;
  real_T t136;
  real_T t137;
  real_T t138;
  real_T t139;
  real_T t140;
  real_T t141;
  real_T t142;
  real_T t143;
  real_T t144;
  real_T t145;
  real_T t146;
  real_T t147;
  real_T t148;
  real_T t149;
  real_T t150;
  real_T t151;
  real_T t152;
  real_T t153;
  real_T t154;
  real_T t155;
  real_T t156;
  real_T t157;
  real_T t158;
  real_T t159;
  real_T t160;
  real_T t161;
  real_T t162;
  real_T t163;
  real_T t164;
  real_T t165;
  real_T t166;
  real_T t167;
  real_T t168;
  real_T t169;
  real_T t170;
  real_T t171;
  real_T t172;
  real_T t173;
  real_T t174;
  real_T t175;
  real_T t176;
  real_T t177;
  real_T t178;
  real_T t179;
  real_T t180;
  real_T t181;
  real_T t182;
  real_T t183;
  real_T t184;
  real_T t185;
  real_T t186;
  real_T t187;
  real_T t188;
  real_T t189;
  real_T t190;
  real_T t191;
  real_T t192;
  real_T t193;
  real_T t194;
  real_T t195;
  real_T t196;
  real_T t197;

  /* LAUTOEVAL */
  /*     [EVAL,DEVAL] = LAUTOEVAL(IN1,IN2,IN3,IN4,IN5) */
  /*     This function was generated by the Symbolic Math Toolbox version 8.4. */
  /*     02-Mar-2020 20:10:26 */
  t110 = MPCparam_Xr[0] + -x[0];
  t111 = MPCparam_Xr[8] + -x[10];
  t112 = MPCparam_Xr[16] + -x[20];
  t113 = MPCparam_Xr[24] + -x[30];
  t114 = MPCparam_Xr[32] + -x[40];
  t115 = MPCparam_Xr[40] + -x[50];
  t116 = MPCparam_Xr[48] + -x[60];
  t117 = MPCparam_Xr[56] + -x[70];
  t118 = MPCparam_Xr[64] + -x[80];
  t119 = MPCparam_Xr[1] + -x[1];
  t120 = MPCparam_Xr[9] + -x[11];
  t121 = MPCparam_Xr[17] + -x[21];
  t122 = MPCparam_Xr[25] + -x[31];
  t123 = MPCparam_Xr[33] + -x[41];
  t124 = MPCparam_Xr[41] + -x[51];
  t125 = MPCparam_Xr[49] + -x[61];
  t126 = MPCparam_Xr[57] + -x[71];
  t127 = MPCparam_Xr[65] + -x[81];
  t128 = MPCparam_Xr[2] + -x[2];
  t129 = MPCparam_Xr[10] + -x[12];
  t130 = MPCparam_Xr[18] + -x[22];
  t131 = MPCparam_Xr[26] + -x[32];
  t132 = MPCparam_Xr[34] + -x[42];
  t133 = MPCparam_Xr[42] + -x[52];
  t134 = MPCparam_Xr[50] + -x[62];
  t135 = MPCparam_Xr[58] + -x[72];
  t136 = MPCparam_Xr[66] + -x[82];
  t137 = MPCparam_Xr[3] + -x[3];
  t138 = MPCparam_Xr[11] + -x[13];
  t139 = MPCparam_Xr[19] + -x[23];
  t140 = MPCparam_Xr[27] + -x[33];
  t141 = MPCparam_Xr[35] + -x[43];
  t142 = MPCparam_Xr[43] + -x[53];
  t143 = MPCparam_Xr[51] + -x[63];
  t144 = MPCparam_Xr[59] + -x[73];
  t145 = MPCparam_Xr[67] + -x[83];
  t146 = MPCparam_Xr[4] + -x[4];
  t147 = MPCparam_Xr[12] + -x[14];
  t148 = MPCparam_Xr[20] + -x[24];
  t149 = MPCparam_Xr[28] + -x[34];
  t150 = MPCparam_Xr[36] + -x[44];
  t151 = MPCparam_Xr[44] + -x[54];
  t152 = MPCparam_Xr[52] + -x[64];
  t153 = MPCparam_Xr[60] + -x[74];
  t154 = MPCparam_Xr[68] + -x[84];
  t155 = MPCparam_Xr[5] + -x[5];
  t156 = MPCparam_Xr[13] + -x[15];
  t157 = MPCparam_Xr[21] + -x[25];
  t158 = MPCparam_Xr[29] + -x[35];
  t159 = MPCparam_Xr[37] + -x[45];
  t160 = MPCparam_Xr[45] + -x[55];
  t161 = MPCparam_Xr[53] + -x[65];
  t162 = MPCparam_Xr[61] + -x[75];
  t163 = MPCparam_Xr[69] + -x[85];
  t164 = MPCparam_Xr[6] + -x[6];
  t165 = MPCparam_Xr[14] + -x[16];
  t166 = MPCparam_Xr[22] + -x[26];
  t167 = MPCparam_Xr[30] + -x[36];
  t168 = MPCparam_Xr[38] + -x[46];
  t169 = MPCparam_Xr[46] + -x[56];
  t170 = MPCparam_Xr[54] + -x[66];
  t171 = MPCparam_Xr[62] + -x[76];
  t172 = MPCparam_Xr[70] + -x[86];
  t173 = MPCparam_Xr[7] + -x[7];
  t174 = MPCparam_Xr[15] + -x[17];
  t175 = MPCparam_Xr[23] + -x[27];
  t176 = MPCparam_Xr[31] + -x[37];
  t177 = MPCparam_Xr[39] + -x[47];
  t178 = MPCparam_Xr[47] + -x[57];
  t179 = MPCparam_Xr[55] + -x[67];
  t180 = MPCparam_Xr[63] + -x[77];
  t181 = MPCparam_Xr[71] + -x[87];
  t182 = MPCparam_Xr[72] + -x[90];
  t183 = MPCparam_Xr[80] + -x[100];
  t184 = MPCparam_Xr[73] + -x[91];
  t185 = MPCparam_Xr[81] + -x[101];
  t186 = MPCparam_Xr[74] + -x[92];
  t187 = MPCparam_Xr[82] + -x[102];
  t188 = MPCparam_Xr[75] + -x[93];
  t189 = MPCparam_Xr[83] + -x[103];
  t190 = MPCparam_Xr[76] + -x[94];
  t191 = MPCparam_Xr[84] + -x[104];
  t192 = MPCparam_Xr[77] + -x[95];
  t193 = MPCparam_Xr[85] + -x[105];
  t194 = MPCparam_Xr[78] + -x[96];
  t195 = MPCparam_Xr[86] + -x[106];
  t196 = MPCparam_Xr[79] + -x[97];
  t197 = MPCparam_Xr[87] + -x[107];
  return
    (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
    (((((((((((((((((((((((((((((t183 * (((((((MPCparam_Qf[1] * t185 +
    MPCparam_Qf[2] * t187) + MPCparam_Qf[3] * t189) + MPCparam_Qf[4] * t191) +
    MPCparam_Qf[5] * t193) + MPCparam_Qf[6] * t195) + MPCparam_Qf[7] * t197) +
    MPCparam_Qf[0] * t183) + t185 * (((((((MPCparam_Qf[8] * t183 + MPCparam_Qf
    [10] * t187) + MPCparam_Qf[11] * t189) + MPCparam_Qf[12] * t191) +
    MPCparam_Qf[13] * t193) + MPCparam_Qf[14] * t195) + MPCparam_Qf[15] * t197)
    + MPCparam_Qf[9] * t185)) + t187 * (((((((MPCparam_Qf[16] * t183 +
    MPCparam_Qf[17] * t185) + MPCparam_Qf[19] * t189) + MPCparam_Qf[20] * t191)
    + MPCparam_Qf[21] * t193) + MPCparam_Qf[22] * t195) + MPCparam_Qf[23] * t197)
    + MPCparam_Qf[18] * t187)) + t189 * (((((((MPCparam_Qf[24] * t183 +
    MPCparam_Qf[25] * t185) + MPCparam_Qf[26] * t187) + MPCparam_Qf[28] * t191)
    + MPCparam_Qf[29] * t193) + MPCparam_Qf[30] * t195) + MPCparam_Qf[31] * t197)
    + MPCparam_Qf[27] * t189)) + t191 * (((((((MPCparam_Qf[32] * t183 +
    MPCparam_Qf[33] * t185) + MPCparam_Qf[34] * t187) + MPCparam_Qf[35] * t189)
    + MPCparam_Qf[37] * t193) + MPCparam_Qf[38] * t195) + MPCparam_Qf[39] * t197)
    + MPCparam_Qf[36] * t191)) + t193 * (((((((MPCparam_Qf[40] * t183 +
    MPCparam_Qf[41] * t185) + MPCparam_Qf[42] * t187) + MPCparam_Qf[43] * t189)
    + MPCparam_Qf[44] * t191) + MPCparam_Qf[46] * t195) + MPCparam_Qf[47] * t197)
    + MPCparam_Qf[45] * t193)) + t195 * (((((((MPCparam_Qf[48] * t183 +
    MPCparam_Qf[49] * t185) + MPCparam_Qf[50] * t187) + MPCparam_Qf[51] * t189)
    + MPCparam_Qf[52] * t191) + MPCparam_Qf[53] * t193) + MPCparam_Qf[55] * t197)
    + MPCparam_Qf[54] * t195)) + t197 * (((((((MPCparam_Qf[56] * t183 +
    MPCparam_Qf[57] * t185) + MPCparam_Qf[58] * t187) + MPCparam_Qf[59] * t189)
    + MPCparam_Qf[60] * t191) + MPCparam_Qf[61] * t193) + MPCparam_Qf[62] * t195)
    + MPCparam_Qf[63] * t197)) + t173 * (((((((MPCparam_Q[56] * t110 +
    MPCparam_Q[57] * t119) + MPCparam_Q[58] * t128) + MPCparam_Q[59] * t137) +
    MPCparam_Q[60] * t146) + MPCparam_Q[61] * t155) + MPCparam_Q[62] * t164) +
    MPCparam_Q[63] * t173)) + t164 * (((((((MPCparam_Q[48] * t110 + MPCparam_Q
    [49] * t119) + MPCparam_Q[50] * t128) + MPCparam_Q[51] * t137) + MPCparam_Q
    [52] * t146) + MPCparam_Q[53] * t155) + MPCparam_Q[55] * t173) + MPCparam_Q
    [54] * t164)) + t155 * (((((((MPCparam_Q[40] * t110 + MPCparam_Q[41] * t119)
    + MPCparam_Q[42] * t128) + MPCparam_Q[43] * t137) + MPCparam_Q[44] * t146) +
    MPCparam_Q[46] * t164) + MPCparam_Q[47] * t173) + MPCparam_Q[45] * t155)) +
    t146 * (((((((MPCparam_Q[32] * t110 + MPCparam_Q[33] * t119) + MPCparam_Q[34]
    * t128) + MPCparam_Q[35] * t137) + MPCparam_Q[37] * t155) + MPCparam_Q[38] *
    t164) + MPCparam_Q[39] * t173) + MPCparam_Q[36] * t146)) + t174 *
    (((((((MPCparam_Q[56] * t111 + MPCparam_Q[57] * t120) + MPCparam_Q[58] *
    t129) + MPCparam_Q[59] * t138) + MPCparam_Q[60] * t147) + MPCparam_Q[61] *
    t156) + MPCparam_Q[62] * t165) + MPCparam_Q[63] * t174)) + t137 *
    (((((((MPCparam_Q[24] * t110 + MPCparam_Q[25] * t119) + MPCparam_Q[26] *
    t128) + MPCparam_Q[28] * t146) + MPCparam_Q[29] * t155) + MPCparam_Q[30] *
    t164) + MPCparam_Q[31] * t173) + MPCparam_Q[27] * t137)) + t165 *
    (((((((MPCparam_Q[48] * t111 + MPCparam_Q[49] * t120) + MPCparam_Q[50] *
    t129) + MPCparam_Q[51] * t138) + MPCparam_Q[52] * t147) + MPCparam_Q[53] *
    t156) + MPCparam_Q[55] * t174) + MPCparam_Q[54] * t165)) + t156 *
    (((((((MPCparam_Q[40] * t111 + MPCparam_Q[41] * t120) + MPCparam_Q[42] *
    t129) + MPCparam_Q[43] * t138) + MPCparam_Q[44] * t147) + MPCparam_Q[46] *
    t165) + MPCparam_Q[47] * t174) + MPCparam_Q[45] * t156)) + t128 *
    (((((((MPCparam_Q[16] * t110 + MPCparam_Q[17] * t119) + MPCparam_Q[19] *
    t137) + MPCparam_Q[20] * t146) + MPCparam_Q[21] * t155) + MPCparam_Q[22] *
    t164) + MPCparam_Q[23] * t173) + MPCparam_Q[18] * t128)) + t147 *
    (((((((MPCparam_Q[32] * t111 + MPCparam_Q[33] * t120) + MPCparam_Q[34] *
    t129) + MPCparam_Q[35] * t138) + MPCparam_Q[37] * t156) + MPCparam_Q[38] *
    t165) + MPCparam_Q[39] * t174) + MPCparam_Q[36] * t147)) + t138 *
    (((((((MPCparam_Q[24] * t111 + MPCparam_Q[25] * t120) + MPCparam_Q[26] *
    t129) + MPCparam_Q[28] * t147) + MPCparam_Q[29] * t156) + MPCparam_Q[30] *
    t165) + MPCparam_Q[31] * t174) + MPCparam_Q[27] * t138)) + t175 *
    (((((((MPCparam_Q[56] * t112 + MPCparam_Q[57] * t121) + MPCparam_Q[58] *
    t130) + MPCparam_Q[59] * t139) + MPCparam_Q[60] * t148) + MPCparam_Q[61] *
    t157) + MPCparam_Q[62] * t166) + MPCparam_Q[63] * t175)) + t119 *
    (((((((MPCparam_Q[8] * t110 + MPCparam_Q[10] * t128) + MPCparam_Q[11] * t137)
    + MPCparam_Q[12] * t146) + MPCparam_Q[13] * t155) + MPCparam_Q[14] * t164) +
    MPCparam_Q[15] * t173) + MPCparam_Q[9] * t119)) + t129 * (((((((MPCparam_Q
    [16] * t111 + MPCparam_Q[17] * t120) + MPCparam_Q[19] * t138) + MPCparam_Q
    [20] * t147) + MPCparam_Q[21] * t156) + MPCparam_Q[22] * t165) + MPCparam_Q
    [23] * t174) + MPCparam_Q[18] * t129)) + t166 * (((((((MPCparam_Q[48] * t112
    + MPCparam_Q[49] * t121) + MPCparam_Q[50] * t130) + MPCparam_Q[51] * t139) +
    MPCparam_Q[52] * t148) + MPCparam_Q[53] * t157) + MPCparam_Q[55] * t175) +
    MPCparam_Q[54] * t166)) + t157 * (((((((MPCparam_Q[40] * t112 + MPCparam_Q
    [41] * t121) + MPCparam_Q[42] * t130) + MPCparam_Q[43] * t139) + MPCparam_Q
    [44] * t148) + MPCparam_Q[46] * t166) + MPCparam_Q[47] * t175) + MPCparam_Q
    [45] * t157)) + t120 * (((((((MPCparam_Q[8] * t111 + MPCparam_Q[10] * t129)
    + MPCparam_Q[11] * t138) + MPCparam_Q[12] * t147) + MPCparam_Q[13] * t156) +
    MPCparam_Q[14] * t165) + MPCparam_Q[15] * t174) + MPCparam_Q[9] * t120)) +
    t110 * (((((((MPCparam_Q[1] * t119 + MPCparam_Q[2] * t128) + MPCparam_Q[3] *
    t137) + MPCparam_Q[4] * t146) + MPCparam_Q[5] * t155) + MPCparam_Q[6] * t164)
    + MPCparam_Q[7] * t173) + MPCparam_Q[0] * t110)) + t148 * (((((((MPCparam_Q
    [32] * t112 + MPCparam_Q[33] * t121) + MPCparam_Q[34] * t130) + MPCparam_Q
    [35] * t139) + MPCparam_Q[37] * t157) + MPCparam_Q[38] * t166) + MPCparam_Q
    [39] * t175) + MPCparam_Q[36] * t148)) + t139 * (((((((MPCparam_Q[24] * t112
    + MPCparam_Q[25] * t121) + MPCparam_Q[26] * t130) + MPCparam_Q[28] * t148) +
    MPCparam_Q[29] * t157) + MPCparam_Q[30] * t166) + MPCparam_Q[31] * t175) +
    MPCparam_Q[27] * t139)) + t111 * (((((((MPCparam_Q[1] * t120 + MPCparam_Q[2]
    * t129) + MPCparam_Q[3] * t138) + MPCparam_Q[4] * t147) + MPCparam_Q[5] *
    t156) + MPCparam_Q[6] * t165) + MPCparam_Q[7] * t174) + MPCparam_Q[0] * t111))
    + t130 * (((((((MPCparam_Q[16] * t112 + MPCparam_Q[17] * t121) + MPCparam_Q
    [19] * t139) + MPCparam_Q[20] * t148) + MPCparam_Q[21] * t157) + MPCparam_Q
    [22] * t166) + MPCparam_Q[23] * t175) + MPCparam_Q[18] * t130)) + t176 *
    (((((((MPCparam_Q[56] * t113 + MPCparam_Q[57] * t122) + MPCparam_Q[58] *
    t131) + MPCparam_Q[59] * t140) + MPCparam_Q[60] * t149) + MPCparam_Q[61] *
    t158) + MPCparam_Q[62] * t167) + MPCparam_Q[63] * t176)) + t121 *
    (((((((MPCparam_Q[8] * t112 + MPCparam_Q[10] * t130) + MPCparam_Q[11] * t139)
    + MPCparam_Q[12] * t148) + MPCparam_Q[13] * t157) + MPCparam_Q[14] * t166) +
    MPCparam_Q[15] * t175) + MPCparam_Q[9] * t121)) + t167 * (((((((MPCparam_Q
    [48] * t113 + MPCparam_Q[49] * t122) + MPCparam_Q[50] * t131) + MPCparam_Q
    [51] * t140) + MPCparam_Q[52] * t149) + MPCparam_Q[53] * t158) + MPCparam_Q
    [55] * t176) + MPCparam_Q[54] * t167)) + t112 * (((((((MPCparam_Q[1] * t121
    + MPCparam_Q[2] * t130) + MPCparam_Q[3] * t139) + MPCparam_Q[4] * t148) +
    MPCparam_Q[5] * t157) + MPCparam_Q[6] * t166) + MPCparam_Q[7] * t175) +
    MPCparam_Q[0] * t112)) + t158 * (((((((MPCparam_Q[40] * t113 + MPCparam_Q[41]
    * t122) + MPCparam_Q[42] * t131) + MPCparam_Q[43] * t140) + MPCparam_Q[44] *
    t149) + MPCparam_Q[46] * t167) + MPCparam_Q[47] * t176) + MPCparam_Q[45] *
    t158)) + t149 * (((((((MPCparam_Q[32] * t113 + MPCparam_Q[33] * t122) +
    MPCparam_Q[34] * t131) + MPCparam_Q[35] * t140) + MPCparam_Q[37] * t158) +
    MPCparam_Q[38] * t167) + MPCparam_Q[39] * t176) + MPCparam_Q[36] * t149)) +
    t140 * (((((((MPCparam_Q[24] * t113 + MPCparam_Q[25] * t122) + MPCparam_Q[26]
    * t131) + MPCparam_Q[28] * t149) + MPCparam_Q[29] * t158) + MPCparam_Q[30] *
    t167) + MPCparam_Q[31] * t176) + MPCparam_Q[27] * t140)) + t131 *
    (((((((MPCparam_Q[16] * t113 + MPCparam_Q[17] * t122) + MPCparam_Q[19] *
    t140) + MPCparam_Q[20] * t149) + MPCparam_Q[21] * t158) + MPCparam_Q[22] *
    t167) + MPCparam_Q[23] * t176) + MPCparam_Q[18] * t131)) + t122 *
    (((((((MPCparam_Q[8] * t113 + MPCparam_Q[10] * t131) + MPCparam_Q[11] * t140)
    + MPCparam_Q[12] * t149) + MPCparam_Q[13] * t158) + MPCparam_Q[14] * t167) +
    MPCparam_Q[15] * t176) + MPCparam_Q[9] * t122)) + t177 * (((((((MPCparam_Q
    [56] * t114 + MPCparam_Q[57] * t123) + MPCparam_Q[58] * t132) + MPCparam_Q
    [59] * t141) + MPCparam_Q[60] * t150) + MPCparam_Q[61] * t159) + MPCparam_Q
    [62] * t168) + MPCparam_Q[63] * t177)) + t113 * (((((((MPCparam_Q[1] * t122
    + MPCparam_Q[2] * t131) + MPCparam_Q[3] * t140) + MPCparam_Q[4] * t149) +
    MPCparam_Q[5] * t158) + MPCparam_Q[6] * t167) + MPCparam_Q[7] * t176) +
    MPCparam_Q[0] * t113)) + t168 * (((((((MPCparam_Q[48] * t114 + MPCparam_Q[49]
    * t123) + MPCparam_Q[50] * t132) + MPCparam_Q[51] * t141) + MPCparam_Q[52] *
    t150) + MPCparam_Q[53] * t159) + MPCparam_Q[55] * t177) + MPCparam_Q[54] *
    t168)) + t159 * (((((((MPCparam_Q[40] * t114 + MPCparam_Q[41] * t123) +
    MPCparam_Q[42] * t132) + MPCparam_Q[43] * t141) + MPCparam_Q[44] * t150) +
    MPCparam_Q[46] * t168) + MPCparam_Q[47] * t177) + MPCparam_Q[45] * t159)) +
    t150 * (((((((MPCparam_Q[32] * t114 + MPCparam_Q[33] * t123) + MPCparam_Q[34]
    * t132) + MPCparam_Q[35] * t141) + MPCparam_Q[37] * t159) + MPCparam_Q[38] *
    t168) + MPCparam_Q[39] * t177) + MPCparam_Q[36] * t150)) + t141 *
    (((((((MPCparam_Q[24] * t114 + MPCparam_Q[25] * t123) + MPCparam_Q[26] *
    t132) + MPCparam_Q[28] * t150) + MPCparam_Q[29] * t159) + MPCparam_Q[30] *
    t168) + MPCparam_Q[31] * t177) + MPCparam_Q[27] * t141)) + t132 *
    (((((((MPCparam_Q[16] * t114 + MPCparam_Q[17] * t123) + MPCparam_Q[19] *
    t141) + MPCparam_Q[20] * t150) + MPCparam_Q[21] * t159) + MPCparam_Q[22] *
    t168) + MPCparam_Q[23] * t177) + MPCparam_Q[18] * t132)) + t123 *
    (((((((MPCparam_Q[8] * t114 + MPCparam_Q[10] * t132) + MPCparam_Q[11] * t141)
    + MPCparam_Q[12] * t150) + MPCparam_Q[13] * t159) + MPCparam_Q[14] * t168) +
    MPCparam_Q[15] * t177) + MPCparam_Q[9] * t123)) + t178 * (((((((MPCparam_Q
    [56] * t115 + MPCparam_Q[57] * t124) + MPCparam_Q[58] * t133) + MPCparam_Q
    [59] * t142) + MPCparam_Q[60] * t151) + MPCparam_Q[61] * t160) + MPCparam_Q
    [62] * t169) + MPCparam_Q[63] * t178)) + t114 * (((((((MPCparam_Q[1] * t123
    + MPCparam_Q[2] * t132) + MPCparam_Q[3] * t141) + MPCparam_Q[4] * t150) +
    MPCparam_Q[5] * t159) + MPCparam_Q[6] * t168) + MPCparam_Q[7] * t177) +
    MPCparam_Q[0] * t114)) + t169 * (((((((MPCparam_Q[48] * t115 + MPCparam_Q[49]
    * t124) + MPCparam_Q[50] * t133) + MPCparam_Q[51] * t142) + MPCparam_Q[52] *
    t151) + MPCparam_Q[53] * t160) + MPCparam_Q[55] * t178) + MPCparam_Q[54] *
    t169)) + t160 * (((((((MPCparam_Q[40] * t115 + MPCparam_Q[41] * t124) +
    MPCparam_Q[42] * t133) + MPCparam_Q[43] * t142) + MPCparam_Q[44] * t151) +
    MPCparam_Q[46] * t169) + MPCparam_Q[47] * t178) + MPCparam_Q[45] * t160)) +
    t151 * (((((((MPCparam_Q[32] * t115 + MPCparam_Q[33] * t124) + MPCparam_Q[34]
    * t133) + MPCparam_Q[35] * t142) + MPCparam_Q[37] * t160) + MPCparam_Q[38] *
    t169) + MPCparam_Q[39] * t178) + MPCparam_Q[36] * t151)) + t142 *
    (((((((MPCparam_Q[24] * t115 + MPCparam_Q[25] * t124) + MPCparam_Q[26] *
    t133) + MPCparam_Q[28] * t151) + MPCparam_Q[29] * t160) + MPCparam_Q[30] *
    t169) + MPCparam_Q[31] * t178) + MPCparam_Q[27] * t142)) + t179 *
    (((((((MPCparam_Q[56] * t116 + MPCparam_Q[57] * t125) + MPCparam_Q[58] *
    t134) + MPCparam_Q[59] * t143) + MPCparam_Q[60] * t152) + MPCparam_Q[61] *
    t161) + MPCparam_Q[62] * t170) + MPCparam_Q[63] * t179)) + t133 *
    (((((((MPCparam_Q[16] * t115 + MPCparam_Q[17] * t124) + MPCparam_Q[19] *
    t142) + MPCparam_Q[20] * t151) + MPCparam_Q[21] * t160) + MPCparam_Q[22] *
    t169) + MPCparam_Q[23] * t178) + MPCparam_Q[18] * t133)) + t124 *
    (((((((MPCparam_Q[8] * t115 + MPCparam_Q[10] * t133) + MPCparam_Q[11] * t142)
    + MPCparam_Q[12] * t151) + MPCparam_Q[13] * t160) + MPCparam_Q[14] * t169) +
    MPCparam_Q[15] * t178) + MPCparam_Q[9] * t124)) + t115 * (((((((MPCparam_Q[1]
    * t124 + MPCparam_Q[2] * t133) + MPCparam_Q[3] * t142) + MPCparam_Q[4] *
    t151) + MPCparam_Q[5] * t160) + MPCparam_Q[6] * t169) + MPCparam_Q[7] * t178)
    + MPCparam_Q[0] * t115)) + t170 * (((((((MPCparam_Q[48] * t116 + MPCparam_Q
    [49] * t125) + MPCparam_Q[50] * t134) + MPCparam_Q[51] * t143) + MPCparam_Q
    [52] * t152) + MPCparam_Q[53] * t161) + MPCparam_Q[55] * t179) + MPCparam_Q
    [54] * t170)) + t180 * (((((((MPCparam_Q[56] * t117 + MPCparam_Q[57] * t126)
    + MPCparam_Q[58] * t135) + MPCparam_Q[59] * t144) + MPCparam_Q[60] * t153) +
    MPCparam_Q[61] * t162) + MPCparam_Q[62] * t171) + MPCparam_Q[63] * t180)) +
    t161 * (((((((MPCparam_Q[40] * t116 + MPCparam_Q[41] * t125) + MPCparam_Q[42]
    * t134) + MPCparam_Q[43] * t143) + MPCparam_Q[44] * t152) + MPCparam_Q[46] *
    t170) + MPCparam_Q[47] * t179) + MPCparam_Q[45] * t161)) + t152 *
    (((((((MPCparam_Q[32] * t116 + MPCparam_Q[33] * t125) + MPCparam_Q[34] *
    t134) + MPCparam_Q[35] * t143) + MPCparam_Q[37] * t161) + MPCparam_Q[38] *
    t170) + MPCparam_Q[39] * t179) + MPCparam_Q[36] * t152)) + t143 *
    (((((((MPCparam_Q[24] * t116 + MPCparam_Q[25] * t125) + MPCparam_Q[26] *
    t134) + MPCparam_Q[28] * t152) + MPCparam_Q[29] * t161) + MPCparam_Q[30] *
    t170) + MPCparam_Q[31] * t179) + MPCparam_Q[27] * t143)) + t181 *
    (((((((MPCparam_Q[56] * t118 + MPCparam_Q[57] * t127) + MPCparam_Q[58] *
    t136) + MPCparam_Q[59] * t145) + MPCparam_Q[60] * t154) + MPCparam_Q[61] *
    t163) + MPCparam_Q[62] * t172) + MPCparam_Q[63] * t181)) + t171 *
    (((((((MPCparam_Q[48] * t117 + MPCparam_Q[49] * t126) + MPCparam_Q[50] *
    t135) + MPCparam_Q[51] * t144) + MPCparam_Q[52] * t153) + MPCparam_Q[53] *
    t162) + MPCparam_Q[55] * t180) + MPCparam_Q[54] * t171)) + t134 *
    (((((((MPCparam_Q[16] * t116 + MPCparam_Q[17] * t125) + MPCparam_Q[19] *
    t143) + MPCparam_Q[20] * t152) + MPCparam_Q[21] * t161) + MPCparam_Q[22] *
    t170) + MPCparam_Q[23] * t179) + MPCparam_Q[18] * t134)) + t125 *
    (((((((MPCparam_Q[8] * t116 + MPCparam_Q[10] * t134) + MPCparam_Q[11] * t143)
    + MPCparam_Q[12] * t152) + MPCparam_Q[13] * t161) + MPCparam_Q[14] * t170) +
    MPCparam_Q[15] * t179) + MPCparam_Q[9] * t125)) + t116 * (((((((MPCparam_Q[1]
    * t125 + MPCparam_Q[2] * t134) + MPCparam_Q[3] * t143) + MPCparam_Q[4] *
    t152) + MPCparam_Q[5] * t161) + MPCparam_Q[6] * t170) + MPCparam_Q[7] * t179)
    + MPCparam_Q[0] * t116)) + t162 * (((((((MPCparam_Q[40] * t117 + MPCparam_Q
    [41] * t126) + MPCparam_Q[42] * t135) + MPCparam_Q[43] * t144) + MPCparam_Q
    [44] * t153) + MPCparam_Q[46] * t171) + MPCparam_Q[47] * t180) + MPCparam_Q
    [45] * t162)) + t172 * (((((((MPCparam_Q[48] * t118 + MPCparam_Q[49] * t127)
    + MPCparam_Q[50] * t136) + MPCparam_Q[51] * t145) + MPCparam_Q[52] * t154) +
    MPCparam_Q[53] * t163) + MPCparam_Q[55] * t181) + MPCparam_Q[54] * t172)) +
    t153 * (((((((MPCparam_Q[32] * t117 + MPCparam_Q[33] * t126) + MPCparam_Q[34]
    * t135) + MPCparam_Q[35] * t144) + MPCparam_Q[37] * t162) + MPCparam_Q[38] *
    t171) + MPCparam_Q[39] * t180) + MPCparam_Q[36] * t153)) + t144 *
    (((((((MPCparam_Q[24] * t117 + MPCparam_Q[25] * t126) + MPCparam_Q[26] *
    t135) + MPCparam_Q[28] * t153) + MPCparam_Q[29] * t162) + MPCparam_Q[30] *
    t171) + MPCparam_Q[31] * t180) + MPCparam_Q[27] * t144)) + t163 *
    (((((((MPCparam_Q[40] * t118 + MPCparam_Q[41] * t127) + MPCparam_Q[42] *
    t136) + MPCparam_Q[43] * t145) + MPCparam_Q[44] * t154) + MPCparam_Q[46] *
    t172) + MPCparam_Q[47] * t181) + MPCparam_Q[45] * t163)) + t135 *
    (((((((MPCparam_Q[16] * t117 + MPCparam_Q[17] * t126) + MPCparam_Q[19] *
    t144) + MPCparam_Q[20] * t153) + MPCparam_Q[21] * t162) + MPCparam_Q[22] *
    t171) + MPCparam_Q[23] * t180) + MPCparam_Q[18] * t135)) + t126 *
    (((((((MPCparam_Q[8] * t117 + MPCparam_Q[10] * t135) + MPCparam_Q[11] * t144)
    + MPCparam_Q[12] * t153) + MPCparam_Q[13] * t162) + MPCparam_Q[14] * t171) +
    MPCparam_Q[15] * t180) + MPCparam_Q[9] * t126)) + t117 * (((((((MPCparam_Q[1]
    * t126 + MPCparam_Q[2] * t135) + MPCparam_Q[3] * t144) + MPCparam_Q[4] *
    t153) + MPCparam_Q[5] * t162) + MPCparam_Q[6] * t171) + MPCparam_Q[7] * t180)
    + MPCparam_Q[0] * t117)) + t154 * (((((((MPCparam_Q[32] * t118 + MPCparam_Q
    [33] * t127) + MPCparam_Q[34] * t136) + MPCparam_Q[35] * t145) + MPCparam_Q
    [37] * t163) + MPCparam_Q[38] * t172) + MPCparam_Q[39] * t181) + MPCparam_Q
    [36] * t154)) + t145 * (((((((MPCparam_Q[24] * t118 + MPCparam_Q[25] * t127)
    + MPCparam_Q[26] * t136) + MPCparam_Q[28] * t154) + MPCparam_Q[29] * t163) +
    MPCparam_Q[30] * t172) + MPCparam_Q[31] * t181) + MPCparam_Q[27] * t145)) +
    t136 * (((((((MPCparam_Q[16] * t118 + MPCparam_Q[17] * t127) + MPCparam_Q[19]
    * t145) + MPCparam_Q[20] * t154) + MPCparam_Q[21] * t163) + MPCparam_Q[22] *
    t172) + MPCparam_Q[23] * t181) + MPCparam_Q[18] * t136)) + t127 *
    (((((((MPCparam_Q[8] * t118 + MPCparam_Q[10] * t136) + MPCparam_Q[11] * t145)
    + MPCparam_Q[12] * t154) + MPCparam_Q[13] * t163) + MPCparam_Q[14] * t172) +
    MPCparam_Q[15] * t181) + MPCparam_Q[9] * t127)) + t118 * (((((((MPCparam_Q[1]
    * t127 + MPCparam_Q[2] * t136) + MPCparam_Q[3] * t145) + MPCparam_Q[4] *
    t154) + MPCparam_Q[5] * t163) + MPCparam_Q[6] * t172) + MPCparam_Q[7] * t181)
    + MPCparam_Q[0] * t118)) + t184 * (((((((MPCparam_Q[8] * t182 + MPCparam_Q
    [10] * t186) + MPCparam_Q[11] * t188) + MPCparam_Q[12] * t190) + MPCparam_Q
    [13] * t192) + MPCparam_Q[14] * t194) + MPCparam_Q[15] * t196) + MPCparam_Q
    [9] * t184)) + t186 * (((((((MPCparam_Q[16] * t182 + MPCparam_Q[17] * t184)
    + MPCparam_Q[19] * t188) + MPCparam_Q[20] * t190) + MPCparam_Q[21] * t192) +
    MPCparam_Q[22] * t194) + MPCparam_Q[23] * t196) + MPCparam_Q[18] * t186)) +
    t188 * (((((((MPCparam_Q[24] * t182 + MPCparam_Q[25] * t184) + MPCparam_Q[26]
    * t186) + MPCparam_Q[28] * t190) + MPCparam_Q[29] * t192) + MPCparam_Q[30] *
    t194) + MPCparam_Q[31] * t196) + MPCparam_Q[27] * t188)) + t190 *
    (((((((MPCparam_Q[32] * t182 + MPCparam_Q[33] * t184) + MPCparam_Q[34] *
    t186) + MPCparam_Q[35] * t188) + MPCparam_Q[37] * t192) + MPCparam_Q[38] *
    t194) + MPCparam_Q[39] * t196) + MPCparam_Q[36] * t190)) + t182 *
    (((((((MPCparam_Q[1] * t184 + MPCparam_Q[2] * t186) + MPCparam_Q[3] * t188)
    + MPCparam_Q[4] * t190) + MPCparam_Q[5] * t192) + MPCparam_Q[6] * t194) +
    MPCparam_Q[7] * t196) + MPCparam_Q[0] * t182)) + t192 * (((((((MPCparam_Q[40]
    * t182 + MPCparam_Q[41] * t184) + MPCparam_Q[42] * t186) + MPCparam_Q[43] *
    t188) + MPCparam_Q[44] * t190) + MPCparam_Q[46] * t194) + MPCparam_Q[47] *
    t196) + MPCparam_Q[45] * t192)) + t194 * (((((((MPCparam_Q[48] * t182 +
    MPCparam_Q[49] * t184) + MPCparam_Q[50] * t186) + MPCparam_Q[51] * t188) +
    MPCparam_Q[52] * t190) + MPCparam_Q[53] * t192) + MPCparam_Q[55] * t196) +
    MPCparam_Q[54] * t194)) + t196 * (((((((MPCparam_Q[56] * t182 + MPCparam_Q
    [57] * t184) + MPCparam_Q[58] * t186) + MPCparam_Q[59] * t188) + MPCparam_Q
    [60] * t190) + MPCparam_Q[61] * t192) + MPCparam_Q[62] * t194) + MPCparam_Q
    [63] * t196)) + x[8] * (MPCparam_R[1] * x[9] + MPCparam_R[0] * x[8])) + x[18]
                      * (MPCparam_R[1] * x[19] + MPCparam_R[0] * x[18])) + x[28]
                     * (MPCparam_R[1] * x[29] + MPCparam_R[0] * x[28])) + x[38] *
                    (MPCparam_R[1] * x[39] + MPCparam_R[0] * x[38])) + x[48] *
                   (MPCparam_R[1] * x[49] + MPCparam_R[0] * x[48])) + x[58] *
                  (MPCparam_R[1] * x[59] + MPCparam_R[0] * x[58])) + x[68] *
                 (MPCparam_R[1] * x[69] + MPCparam_R[0] * x[68])) + x[78] *
                (MPCparam_R[1] * x[79] + MPCparam_R[0] * x[78])) + x[9] *
               (MPCparam_R[2] * x[8] + MPCparam_R[3] * x[9])) + x[88] *
              (MPCparam_R[1] * x[89] + MPCparam_R[0] * x[88])) + x[19] *
             (MPCparam_R[2] * x[18] + MPCparam_R[3] * x[19])) + x[29] *
            (MPCparam_R[2] * x[28] + MPCparam_R[3] * x[29])) + x[39] *
           (MPCparam_R[2] * x[38] + MPCparam_R[3] * x[39])) + x[49] *
          (MPCparam_R[2] * x[48] + MPCparam_R[3] * x[49])) + x[59] *
         (MPCparam_R[2] * x[58] + MPCparam_R[3] * x[59])) + x[69] * (MPCparam_R
         [2] * x[68] + MPCparam_R[3] * x[69])) + x[79] * (MPCparam_R[2] * x[78]
        + MPCparam_R[3] * x[79])) + x[89] * (MPCparam_R[2] * x[88] + MPCparam_R
       [3] * x[89])) + x[98] * (MPCparam_R[1] * x[99] + MPCparam_R[0] * x[98]))
    + x[99] * (MPCparam_R[2] * x[98] + MPCparam_R[3] * x[99]);
}

/* End of code generation (L_HL_MPCfunc.c) */
