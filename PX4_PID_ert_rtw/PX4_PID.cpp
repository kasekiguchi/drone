//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// File: PX4_PID.cpp
//
// Code generated for Simulink model 'PX4_PID'.
//
// Model version                  : 1.10
// Simulink Coder version         : 23.2 (R2023b) 01-Aug-2023
// C/C++ source code generated on : Thu Mar  7 13:10:26 2024
//
// Target selection: ert.tlc
// Embedded hardware selection: ARM Compatible->ARM Cortex
// Code generation objectives: Unspecified
// Validation result: Not run
//
#include "PX4_PID.h"
#include "PX4_PID_types.h"
#include "rtwtypes.h"
#include "PX4_PID_private.h"
#include <uORB/topics/actuator_armed.h>
#include <math.h>

extern "C"
{

#include "rt_nonfinite.h"

}

#include "rt_defines.h"

// Block signals (default storage)
B_PX4_PID_T PX4_PID_B;

// Block states (default storage)
DW_PX4_PID_T PX4_PID_DW;

// Real-time model
RT_MODEL_PX4_PID_T PX4_PID_M_ = RT_MODEL_PX4_PID_T();
RT_MODEL_PX4_PID_T *const PX4_PID_M = &PX4_PID_M_;

// Forward declaration for local functions
static void PX4_PID_expand_atan2(const real_T a_data[], const int32_T *a_size,
  const real_T b_data[], const int32_T *b_size, real_T c_data[], int32_T *c_size);
static void PX4_PID_binary_expand_op(real_T in1[3], const int32_T in2_data[],
  const int32_T *in2_size, const real_T in3_data[], const real_T in4_data[]);
static void PX4_PID_SystemCore_setup(px4_internal_block_PWM_PX4_PI_T *obj,
  boolean_T varargin_1, boolean_T varargin_2);
static void rate_monotonic_scheduler(void);

//
// Set which subrates need to run this base step (base rate always runs).
// This function must be called prior to calling the model step function
// in order to remember which rates need to run this base step.  The
// buffering of events allows for overlapping preemption.
//
void PX4_PID_SetEventsForThisBaseStep(boolean_T *eventFlags)
{
  // Task runs when its counter is zero, computed via rtmStepTask macro
  eventFlags[1] = ((boolean_T)rtmStepTask(PX4_PID_M, 1));
}

//
//         This function updates active task flag for each subrate
//         and rate transition flags for tasks that exchange data.
//         The function assumes rate-monotonic multitasking scheduler.
//         The function must be called at model base rate so that
//         the generated code self-manages all its subrates and rate
//         transition flags.
//
static void rate_monotonic_scheduler(void)
{
  // Compute which subrates run during the next base time step.  Subrates
  //  are an integer multiple of the base rate counter.  Therefore, the subtask
  //  counter is reset when it reaches its limit (zero means run).

  (PX4_PID_M->Timing.TaskCounters.TID[1])++;
  if ((PX4_PID_M->Timing.TaskCounters.TID[1]) > 3) {// Sample time: [0.004s, 0.0s] 
    PX4_PID_M->Timing.TaskCounters.TID[1] = 0;
  }
}

// System initialize for atomic system:
void PX4_PID_SourceBlock_Init(DW_SourceBlock_PX4_PID_T *localDW)
{
  // Start for MATLABSystem: '<S4>/SourceBlock'
  localDW->obj.matlabCodegenIsDeleted = false;
  localDW->objisempty = true;
  localDW->obj.isInitialized = 1;
  localDW->obj.orbMetadataObj = ORB_ID(esc_report);
  uORB_read_initialize(localDW->obj.orbMetadataObj, &localDW->obj.eventStructObj);
  localDW->obj.isSetupComplete = true;
}

// Output and update for atomic system:
void PX4_PID_SourceBlock(B_SourceBlock_PX4_PID_T *localB,
  DW_SourceBlock_PX4_PID_T *localDW)
{
  // MATLABSystem: '<S4>/SourceBlock'
  localB->SourceBlock_o1 = uORB_read_step(localDW->obj.orbMetadataObj,
    &localDW->obj.eventStructObj, &localB->SourceBlock_o2, false, 1.0);
}

// Termination for atomic system:
void PX4_PID_SourceBlock_Term(DW_SourceBlock_PX4_PID_T *localDW)
{
  // Terminate for MATLABSystem: '<S4>/SourceBlock'
  if (!localDW->obj.matlabCodegenIsDeleted) {
    localDW->obj.matlabCodegenIsDeleted = true;
    if ((localDW->obj.isInitialized == 1) && localDW->obj.isSetupComplete) {
      uORB_read_terminate(&localDW->obj.eventStructObj);
    }
  }

  // End of Terminate for MATLABSystem: '<S4>/SourceBlock'
}

real_T rt_atan2d_snf(real_T u0, real_T u1)
{
  real_T y;
  if (rtIsNaN(u0) || rtIsNaN(u1)) {
    y = (rtNaN);
  } else if (rtIsInf(u0) && rtIsInf(u1)) {
    int32_T tmp;
    int32_T tmp_0;
    if (u0 > 0.0) {
      tmp = 1;
    } else {
      tmp = -1;
    }

    if (u1 > 0.0) {
      tmp_0 = 1;
    } else {
      tmp_0 = -1;
    }

    y = atan2(static_cast<real_T>(tmp), static_cast<real_T>(tmp_0));
  } else if (u1 == 0.0) {
    if (u0 > 0.0) {
      y = RT_PI / 2.0;
    } else if (u0 < 0.0) {
      y = -(RT_PI / 2.0);
    } else {
      y = 0.0;
    }
  } else {
    y = atan2(u0, u1);
  }

  return y;
}

static void PX4_PID_expand_atan2(const real_T a_data[], const int32_T *a_size,
  const real_T b_data[], const int32_T *b_size, real_T c_data[], int32_T *c_size)
{
  int32_T csz_idx_0;
  if (*b_size == 1) {
    csz_idx_0 = *a_size;
  } else {
    csz_idx_0 = 0;
  }

  // Start for MATLABSystem: '<S2>/Quad2eul'
  *c_size = csz_idx_0;
  if (csz_idx_0 != 0) {
    *c_size = 1;
    c_data[0] = rt_atan2d_snf(a_data[0], b_data[0]);
  }

  // End of Start for MATLABSystem: '<S2>/Quad2eul'
}

static void PX4_PID_binary_expand_op(real_T in1[3], const int32_T in2_data[],
  const int32_T *in2_size, const real_T in3_data[], const real_T in4_data[])
{
  int32_T in2_idx_0;

  // Start for MATLABSystem: '<S2>/Quad2eul'
  in2_idx_0 = *in2_size;

  // MATLABSystem: '<S2>/Quad2eul'
  for (int32_T i = 0; i < in2_idx_0; i++) {
    in1[in2_data[0]] = -in3_data[0] * 2.0 * in4_data[0];
  }
}

static void PX4_PID_SystemCore_setup(px4_internal_block_PWM_PX4_PI_T *obj,
  boolean_T varargin_1, boolean_T varargin_2)
{
  uint16_T status;
  obj->isSetupComplete = false;

  // Start for MATLABSystem: '<Root>/PX4 PWM Output'
  obj->isInitialized = 1;
  obj->isMain = false;
  obj->pwmDevObj = MW_PWM_OUTPUT_AUX_DEVICE_PATH;
  status = pwm_open(&obj->pwmDevHandler, obj->pwmDevObj,
                    &obj->actuatorAdvertiseObj, &obj->armAdvertiseObj);
  obj->errorStatus = static_cast<uint16_T>(obj->errorStatus | status);
  obj->servoCount = 0;
  status = pwm_getServoCount(&obj->pwmDevHandler, &obj->servoCount);
  obj->errorStatus = static_cast<uint16_T>(obj->errorStatus | status);
  if (varargin_1) {
    status = pwm_arm(&obj->pwmDevHandler, &obj->armAdvertiseObj);
    obj->isArmed = true;
  } else {
    status = pwm_disarm(&obj->pwmDevHandler, &obj->armAdvertiseObj);
    obj->isArmed = false;
  }

  obj->errorStatus = static_cast<uint16_T>(obj->errorStatus | status);
  status = pwm_setPWMRate(&obj->pwmDevHandler, obj->isMain);
  obj->errorStatus = static_cast<uint16_T>(obj->errorStatus | status);
  obj->channelMask = 15;
  status = pwm_setChannelMask(&obj->pwmDevHandler, obj->channelMask);
  obj->errorStatus = static_cast<uint16_T>(obj->errorStatus | status);
  status = pwm_setFailsafePWM(&obj->pwmDevHandler, obj->servoCount,
    obj->channelMask, obj->isMain);
  obj->errorStatus = static_cast<uint16_T>(obj->errorStatus | status);
  status = pwm_setDisarmedPWM(&obj->pwmDevHandler, obj->servoCount,
    obj->channelMask, obj->isMain, &obj->actuatorAdvertiseObj);
  obj->errorStatus = static_cast<uint16_T>(obj->errorStatus | status);
  if (obj->isMain) {
    status = pwm_forceFailsafe(&obj->pwmDevHandler, static_cast<int32_T>
      (varargin_2));
    obj->errorStatus = static_cast<uint16_T>(obj->errorStatus | status);
    status = pwm_forceTerminateFailsafe(&obj->pwmDevHandler, 0);
    obj->errorStatus = static_cast<uint16_T>(obj->errorStatus | status);
  }

  // End of Start for MATLABSystem: '<Root>/PX4 PWM Output'
  obj->isSetupComplete = true;
}

// Model step function for TID0
void PX4_PID_step0(void)               // Sample time: [0.001s, 0.0s]
{
  px4_Bus_actuator_armed b_varargout_2;

  {                                    // Sample time: [0.001s, 0.0s]
    rate_monotonic_scheduler();
  }

  // MATLABSystem: '<S3>/SourceBlock'
  uORB_read_step(PX4_PID_DW.obj_e.orbMetadataObj,
                 &PX4_PID_DW.obj_e.eventStructObj, &b_varargout_2, false, 1.0);
  PX4_PID_SourceBlock(&PX4_PID_B.SourceBlock_c, &PX4_PID_DW.SourceBlock_c);
  PX4_PID_SourceBlock(&PX4_PID_B.SourceBlock_n, &PX4_PID_DW.SourceBlock_n);
}

// Model step function for TID1
void PX4_PID_step1(void)               // Sample time: [0.004s, 0.0s]
{
  real_T b_idx_0;
  int32_T g_data;
  int32_T g_size;
  int32_T h_size_idx_0;
  int32_T i;
  int32_T partialTrueCount;
  int32_T sigIdx;
  uint16_T status;
  uint16_T u1;
  boolean_T mask;
  boolean_T tmp;

  // MATLABSystem: '<S160>/SourceBlock'
  mask = uORB_read_step(PX4_PID_DW.obj_g.orbMetadataObj,
                        &PX4_PID_DW.obj_g.eventStructObj,
                        &PX4_PID_B.b_varargout_2_m, false, 5000.0);

  // Outputs for Enabled SubSystem: '<S160>/Enabled Subsystem' incorporates:
  //   EnablePort: '<S161>/Enable'

  // Start for MATLABSystem: '<S160>/SourceBlock'
  if (mask) {
    // SignalConversion generated from: '<S161>/In1'
    PX4_PID_B.In1_i = PX4_PID_B.b_varargout_2_m;
  }

  // End of Outputs for SubSystem: '<S160>/Enabled Subsystem'

  // MinMax: '<S7>/Min'
  status = PX4_PID_B.In1_i.values[0];
  for (sigIdx = 0; sigIdx < 7; sigIdx++) {
    u1 = PX4_PID_B.In1_i.values[sigIdx + 1];
    if (status > u1) {
      status = u1;
    }
  }

  // Switch: '<S7>/PROPO FS' incorporates:
  //   Constant: '<S7>/Constant2'
  //   Constant: '<S7>/Constant3'
  //   DataTypeConversion: '<S6>/Data Type Conversion'
  //   DataTypeConversion: '<S6>/Data Type Conversion1'
  //   DataTypeConversion: '<S6>/Data Type Conversion2'
  //   Gain: '<S6>/Gain'
  //   Gain: '<S6>/Gain1'
  //   Logic: '<S160>/NOT'
  //   MATLABSystem: '<S160>/SourceBlock'
  //   S-Function (sfix_bitop): '<S6>/Bitwise Operator'
  //
  if ((static_cast<int32_T>((static_cast<uint32_T>(PX4_PID_P.Gain_Gain_k) *
         PX4_PID_B.In1_i.rc_failsafe) >> 6) | static_cast<int32_T>(!mask) |
       static_cast<int32_T>((static_cast<uint32_T>(PX4_PID_P.Gain1_Gain_n) *
         PX4_PID_B.In1_i.rc_lost) >> 5)) >= PX4_PID_P.PROPOFS_Threshold) {
    mask = PX4_PID_P.Constant2_Value_l;
  } else {
    mask = PX4_PID_P.Constant3_Value_m;
  }

  // Switch: '<S7>/Signal FS' incorporates:
  //   Constant: '<S7>/Constant2'
  //   Constant: '<S7>/Constant3'
  //   MinMax: '<S7>/Min'

  if (status >= PX4_PID_P.SignalFS_Threshold) {
    tmp = PX4_PID_P.Constant3_Value_m;
  } else {
    tmp = PX4_PID_P.Constant2_Value_l;
  }

  // Switch: '<S7>/PROPO FS1' incorporates:
  //   Constant: '<S7>/Constant'
  //   Constant: '<S7>/Constant1'
  //   Logic: '<S7>/OR'
  //   Switch: '<S7>/PROPO FS'
  //   Switch: '<S7>/Signal FS'

  if (mask || tmp) {
    PX4_PID_B.PROPOFS1[0] = PX4_PID_P.Constant1_Value;
    PX4_PID_B.PROPOFS1[1] = PX4_PID_P.Constant1_Value;
    PX4_PID_B.PROPOFS1[2] = PX4_PID_P.Constant_Value_g;
    PX4_PID_B.PROPOFS1[3] = PX4_PID_P.Constant1_Value;
    PX4_PID_B.PROPOFS1[4] = PX4_PID_P.Constant_Value_g;
  } else {
    for (i = 0; i < 8; i++) {
      // Saturate: '<S7>/Saturation'
      status = PX4_PID_B.In1_i.values[i];
      if (status > PX4_PID_P.Saturation_UpperSat_o) {
        PX4_PID_B.PROPOFS1[i] = PX4_PID_P.Saturation_UpperSat_o;
      } else if (status < PX4_PID_P.Saturation_LowerSat_p) {
        PX4_PID_B.PROPOFS1[i] = PX4_PID_P.Saturation_LowerSat_p;
      } else {
        PX4_PID_B.PROPOFS1[i] = status;
      }

      // End of Saturate: '<S7>/Saturation'
    }
  }

  // End of Switch: '<S7>/PROPO FS1'

  // MATLABSystem: '<S162>/SourceBlock'
  mask = uORB_read_step(PX4_PID_DW.obj_p.orbMetadataObj,
                        &PX4_PID_DW.obj_p.eventStructObj,
                        &PX4_PID_B.b_varargout_2, false, 1.0);

  // Outputs for Enabled SubSystem: '<S162>/Enabled Subsystem' incorporates:
  //   EnablePort: '<S163>/Enable'

  // Start for MATLABSystem: '<S162>/SourceBlock'
  if (mask) {
    // SignalConversion generated from: '<S163>/In1'
    PX4_PID_B.In1 = PX4_PID_B.b_varargout_2;
  }

  // End of Outputs for SubSystem: '<S162>/Enabled Subsystem'

  // Gain: '<S9>/Gain' incorporates:
  //   Constant: '<Root>/Constant2'
  //   Gain: '<Root>/Gain1'
  //   Sum: '<Root>/Sum2'

  PX4_PID_B.Gain_g = (PX4_PID_B.PROPOFS1[2] - PX4_PID_P.Constant2_Value) *
    PX4_PID_P.Gain1_Gain_g * PX4_PID_P.Gain_Gain;

  // SignalConversion generated from: '<S2>/Transpose' incorporates:
  //   DataTypeConversion: '<S2>/Data Type Conversion2'
  //   Gain: '<S2>/Gain1'
  //   Saturate: '<Root>/PWM Saturation'

  PX4_PID_B.rtb_PWMSaturation_idx_2 = PX4_PID_P.Gain1_Gain * PX4_PID_B.In1.q[2];
  PX4_PID_B.rtb_PWMSaturation_idx_3 = PX4_PID_P.Gain1_Gain * PX4_PID_B.In1.q[3];

  // MATLABSystem: '<S2>/Quad2eul' incorporates:
  //   DataTypeConversion: '<S2>/Data Type Conversion2'
  //   Math: '<S2>/Transpose'
  //   Saturate: '<Root>/PWM Saturation'

  PX4_PID_B.aSinInput = 1.0 / sqrt(((static_cast<real_T>(PX4_PID_B.In1.q[0]) *
    PX4_PID_B.In1.q[0] + static_cast<real_T>(PX4_PID_B.In1.q[1]) *
    PX4_PID_B.In1.q[1]) + PX4_PID_B.rtb_PWMSaturation_idx_2 *
    PX4_PID_B.rtb_PWMSaturation_idx_2) + PX4_PID_B.rtb_PWMSaturation_idx_3 *
    PX4_PID_B.rtb_PWMSaturation_idx_3);
  PX4_PID_B.rtb_PWMSaturation_idx_0 = PX4_PID_B.In1.q[0] * PX4_PID_B.aSinInput;
  PX4_PID_B.rtb_PWMSaturation_idx_1 = PX4_PID_B.In1.q[1] * PX4_PID_B.aSinInput;
  PX4_PID_B.rtb_PWMSaturation_idx_2 *= PX4_PID_B.aSinInput;
  PX4_PID_B.rtb_PWMSaturation_idx_3 *= PX4_PID_B.aSinInput;
  PX4_PID_B.aSinInput = (PX4_PID_B.rtb_PWMSaturation_idx_1 *
    PX4_PID_B.rtb_PWMSaturation_idx_3 - PX4_PID_B.rtb_PWMSaturation_idx_0 *
    PX4_PID_B.rtb_PWMSaturation_idx_2) * -2.0;
  b_idx_0 = PX4_PID_B.aSinInput;
  if (PX4_PID_B.aSinInput >= 0.99999999999999778) {
    b_idx_0 = 1.0;
  }

  if (PX4_PID_B.aSinInput <= -0.99999999999999778) {
    b_idx_0 = -1.0;
  }

  mask = ((PX4_PID_B.aSinInput >= 0.99999999999999778) || (PX4_PID_B.aSinInput <=
           -0.99999999999999778));

  // Start for MATLABSystem: '<S2>/Quad2eul'
  PX4_PID_B.aSinInput = PX4_PID_B.rtb_PWMSaturation_idx_0 *
    PX4_PID_B.rtb_PWMSaturation_idx_0;
  PX4_PID_B.u = PX4_PID_B.rtb_PWMSaturation_idx_1 *
    PX4_PID_B.rtb_PWMSaturation_idx_1;
  PX4_PID_B.out_tmp = PX4_PID_B.rtb_PWMSaturation_idx_2 *
    PX4_PID_B.rtb_PWMSaturation_idx_2;
  PX4_PID_B.out_tmp_k = PX4_PID_B.rtb_PWMSaturation_idx_3 *
    PX4_PID_B.rtb_PWMSaturation_idx_3;

  // MATLABSystem: '<S2>/Quad2eul'
  PX4_PID_B.out[0] = rt_atan2d_snf((PX4_PID_B.rtb_PWMSaturation_idx_1 *
    PX4_PID_B.rtb_PWMSaturation_idx_2 + PX4_PID_B.rtb_PWMSaturation_idx_0 *
    PX4_PID_B.rtb_PWMSaturation_idx_3) * 2.0, ((PX4_PID_B.aSinInput +
    PX4_PID_B.u) - PX4_PID_B.out_tmp) - PX4_PID_B.out_tmp_k);
  PX4_PID_B.out[1] = asin(b_idx_0);
  PX4_PID_B.out[2] = rt_atan2d_snf((PX4_PID_B.rtb_PWMSaturation_idx_2 *
    PX4_PID_B.rtb_PWMSaturation_idx_3 + PX4_PID_B.rtb_PWMSaturation_idx_0 *
    PX4_PID_B.rtb_PWMSaturation_idx_1) * 2.0, ((PX4_PID_B.aSinInput -
    PX4_PID_B.u) - PX4_PID_B.out_tmp) + PX4_PID_B.out_tmp_k);
  sigIdx = 0;

  // MATLABSystem: '<S2>/Quad2eul'
  if (mask) {
    for (i = 0; i < 1; i++) {
      sigIdx++;
    }
  }

  g_size = sigIdx;
  sigIdx = 0;

  // MATLABSystem: '<S2>/Quad2eul'
  if (mask) {
    for (i = 0; i < 1; i++) {
      g_data = 0;
    }

    for (i = 0; i < 1; i++) {
      sigIdx++;
    }
  }

  h_size_idx_0 = sigIdx;
  sigIdx = 0;

  // MATLABSystem: '<S2>/Quad2eul'
  if (mask) {
    for (i = 0; i < 1; i++) {
      sigIdx++;
    }
  }

  if (sigIdx - 1 >= 0) {
    PX4_PID_B.b_x_data = b_idx_0;
  }

  partialTrueCount = 0;

  // Start for MATLABSystem: '<S2>/Quad2eul'
  if (mask) {
    for (i = 0; i < 1; i++) {
      partialTrueCount++;
    }
  }

  // MATLABSystem: '<S2>/Quad2eul'
  i = partialTrueCount - 1;
  for (partialTrueCount = 0; partialTrueCount <= i; partialTrueCount++) {
    if (rtIsNaN(PX4_PID_B.b_x_data)) {
      PX4_PID_B.b_x_data = (rtNaN);
    } else if (PX4_PID_B.b_x_data < 0.0) {
      PX4_PID_B.b_x_data = -1.0;
    } else {
      PX4_PID_B.b_x_data = (PX4_PID_B.b_x_data > 0.0);
    }
  }

  if (g_size == h_size_idx_0) {
    if (g_size - 1 >= 0) {
      PX4_PID_B.j_data = rt_atan2d_snf(PX4_PID_B.rtb_PWMSaturation_idx_1,
        PX4_PID_B.rtb_PWMSaturation_idx_0);
    }
  } else {
    partialTrueCount = 0;
    if (mask) {
      for (i = 0; i < 1; i++) {
        partialTrueCount++;
      }
    }

    if (partialTrueCount - 1 >= 0) {
      PX4_PID_B.rtb_PWMSaturation_data = PX4_PID_B.rtb_PWMSaturation_idx_1;
      PX4_PID_B.rtb_PWMSaturation_data_c = PX4_PID_B.rtb_PWMSaturation_idx_0;
    }

    PX4_PID_expand_atan2(&PX4_PID_B.rtb_PWMSaturation_data, &partialTrueCount,
                         &PX4_PID_B.rtb_PWMSaturation_data_c, &partialTrueCount,
                         &PX4_PID_B.j_data, &g_size);
  }

  partialTrueCount = 0;

  // MATLABSystem: '<S2>/Quad2eul'
  if (mask) {
    for (i = 0; i < 1; i++) {
      partialTrueCount++;
    }
  }

  if (mask) {
    for (i = 0; i < 1; i++) {
      g_data = 0;
    }
  }

  if (sigIdx != g_size) {
    // MATLABSystem: '<S2>/Quad2eul'
    PX4_PID_binary_expand_op(PX4_PID_B.out, &g_data, &partialTrueCount,
      &PX4_PID_B.b_x_data, &PX4_PID_B.j_data);
  }

  sigIdx = 0;

  // MATLABSystem: '<S2>/Quad2eul'
  if (mask) {
    for (i = 0; i < 1; i++) {
      sigIdx++;
    }
  }

  if (sigIdx - 1 >= 0) {
    PX4_PID_B.out[2] = 0.0;
  }

  // Gain: '<S9>/•ª”z' incorporates:
  //   Constant: '<Root>/Constant'
  //   DSPFlip: '<S2>/Flip'
  //   Gain: '<Root>/Gain5'
  //   Gain: '<S97>/Proportional Gain'
  //   Gain: '<S9>/1//L'
  //   MATLABSystem: '<S2>/Quad2eul'
  //   Sum: '<Root>/Sum'
  //   Sum: '<S1>/Sum'
  //
  PX4_PID_B.u = ((PX4_PID_B.PROPOFS1[0] - PX4_PID_P.Constant_Value_g0) *
                 PX4_PID_P.Gain5_Gain - PX4_PID_B.out[2]) * PX4_PID_P.RollPID_P *
    PX4_PID_P.uL_Gain * PX4_PID_P._Gain;

  // Gain: '<S9>/•ª”z1' incorporates:
  //   Constant: '<Root>/Constant'
  //   DSPFlip: '<S2>/Flip'
  //   Gain: '<Root>/Gain5'
  //   Gain: '<S49>/Proportional Gain'
  //   Gain: '<S9>/1//L''
  //   MATLABSystem: '<S2>/Quad2eul'
  //   Sum: '<Root>/Sum'
  //   Sum: '<S1>/Sum1'
  //
  PX4_PID_B.rtb_PWMSaturation_idx_3 = ((PX4_PID_B.PROPOFS1[1] -
    PX4_PID_P.Constant_Value_g0) * PX4_PID_P.Gain5_Gain - PX4_PID_B.out[1]) *
    PX4_PID_P.PitchPID_P * PX4_PID_P.uL_Gain_f * PX4_PID_P.u_Gain;

  // Gain: '<S9>/Gain2' incorporates:
  //   Constant: '<Root>/Constant'
  //   Gain: '<Root>/Gain5'
  //   Gain: '<S145>/Proportional Gain'
  //   Gain: '<S2>/Gain2'
  //   Gain: '<S9>/1//k'
  //   Sum: '<Root>/Sum'
  //   Sum: '<S1>/Sum2'

  PX4_PID_B.rtb_PWMSaturation_idx_0 = ((PX4_PID_B.PROPOFS1[3] -
    PX4_PID_P.Constant_Value_g0) * PX4_PID_P.Gain5_Gain - PX4_PID_P.Gain2_Gain_l
    * PX4_PID_B.In1.yawspeed) * PX4_PID_P.YawPID_P * PX4_PID_P.uk_Gain *
    PX4_PID_P.Gain2_Gain;

  // Sum: '<S9>/Sum3' incorporates:
  //   Sum: '<S9>/Sum6'

  PX4_PID_B.rtb_PWMSaturation_idx_1 = PX4_PID_B.Gain_g - PX4_PID_B.u;

  // Sum: '<S9>/Sum1' incorporates:
  //   Gain: '<S9>/1//b'
  //   Gain: '<S9>/Gain3'
  //   Sum: '<S9>/Sum3'
  //   Sum: '<S9>/Sum7'

  PX4_PID_B.aSinInput = (PX4_PID_B.rtb_PWMSaturation_idx_1 -
    PX4_PID_B.rtb_PWMSaturation_idx_3) * PX4_PID_P.ub_Gain +
    PX4_PID_P.Gain3_Gain * PX4_PID_B.rtb_PWMSaturation_idx_0;

  // Saturate: '<S9>/Saturation'
  if (PX4_PID_B.aSinInput > PX4_PID_P.Saturation_UpperSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.Saturation_UpperSat;
  } else if (PX4_PID_B.aSinInput < PX4_PID_P.Saturation_LowerSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.Saturation_LowerSat;
  }

  // Sum: '<Root>/Sum1' incorporates:
  //   Constant: '<Root>/Constant1'
  //   Gain: '<Root>/Gain'
  //   Saturate: '<S9>/Saturation'
  //   Sqrt: '<S9>/Sqrt'

  PX4_PID_B.aSinInput = PX4_PID_P.Gain_Gain_d * sqrt(PX4_PID_B.aSinInput) +
    PX4_PID_P.Constant1_Value_g;

  // Saturate: '<Root>/PWM Saturation'
  if (PX4_PID_B.aSinInput > PX4_PID_P.PWMSaturation_UpperSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.PWMSaturation_UpperSat;
  } else if (PX4_PID_B.aSinInput < PX4_PID_P.PWMSaturation_LowerSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.PWMSaturation_LowerSat;
  }

  // DataTypeConversion: '<Root>/Data Type Conversion' incorporates:
  //   Saturate: '<Root>/PWM Saturation'

  PX4_PID_B.rtb_PWMSaturation_idx_2 = floor(PX4_PID_B.aSinInput);
  if (rtIsNaN(PX4_PID_B.rtb_PWMSaturation_idx_2) || rtIsInf
      (PX4_PID_B.rtb_PWMSaturation_idx_2)) {
    PX4_PID_B.rtb_PWMSaturation_idx_2 = 0.0;
  } else {
    PX4_PID_B.rtb_PWMSaturation_idx_2 = fmod(PX4_PID_B.rtb_PWMSaturation_idx_2,
      65536.0);
  }

  // Sum: '<S9>/Sum4' incorporates:
  //   Sum: '<S9>/Sum5'

  PX4_PID_B.u += PX4_PID_B.Gain_g;

  // Sum: '<S9>/Sum1' incorporates:
  //   Gain: '<S9>/1//b'
  //   Gain: '<S9>/Gain4'
  //   Sum: '<S9>/Sum4'
  //   Sum: '<S9>/Sum8'

  PX4_PID_B.aSinInput = (PX4_PID_B.u + PX4_PID_B.rtb_PWMSaturation_idx_3) *
    PX4_PID_P.ub_Gain + PX4_PID_P.Gain4_Gain * PX4_PID_B.rtb_PWMSaturation_idx_0;

  // Saturate: '<S9>/Saturation'
  if (PX4_PID_B.aSinInput > PX4_PID_P.Saturation_UpperSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.Saturation_UpperSat;
  } else if (PX4_PID_B.aSinInput < PX4_PID_P.Saturation_LowerSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.Saturation_LowerSat;
  }

  // Sum: '<Root>/Sum1' incorporates:
  //   Constant: '<Root>/Constant1'
  //   Gain: '<Root>/Gain'
  //   Saturate: '<S9>/Saturation'
  //   Sqrt: '<S9>/Sqrt'

  PX4_PID_B.aSinInput = PX4_PID_P.Gain_Gain_d * sqrt(PX4_PID_B.aSinInput) +
    PX4_PID_P.Constant1_Value_g;

  // Saturate: '<Root>/PWM Saturation'
  if (PX4_PID_B.aSinInput > PX4_PID_P.PWMSaturation_UpperSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.PWMSaturation_UpperSat;
  } else if (PX4_PID_B.aSinInput < PX4_PID_P.PWMSaturation_LowerSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.PWMSaturation_LowerSat;
  }

  // DataTypeConversion: '<Root>/Data Type Conversion' incorporates:
  //   Saturate: '<Root>/PWM Saturation'

  PX4_PID_B.Gain_g = floor(PX4_PID_B.aSinInput);
  if (rtIsNaN(PX4_PID_B.Gain_g) || rtIsInf(PX4_PID_B.Gain_g)) {
    PX4_PID_B.Gain_g = 0.0;
  } else {
    PX4_PID_B.Gain_g = fmod(PX4_PID_B.Gain_g, 65536.0);
  }

  // Sum: '<S9>/Sum1' incorporates:
  //   Gain: '<S9>/1//b'
  //   Sum: '<S9>/Sum9'

  PX4_PID_B.aSinInput = (PX4_PID_B.u - PX4_PID_B.rtb_PWMSaturation_idx_3) *
    PX4_PID_P.ub_Gain + PX4_PID_B.rtb_PWMSaturation_idx_0;

  // Saturate: '<S9>/Saturation'
  if (PX4_PID_B.aSinInput > PX4_PID_P.Saturation_UpperSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.Saturation_UpperSat;
  } else if (PX4_PID_B.aSinInput < PX4_PID_P.Saturation_LowerSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.Saturation_LowerSat;
  }

  // Sum: '<Root>/Sum1' incorporates:
  //   Constant: '<Root>/Constant1'
  //   Gain: '<Root>/Gain'
  //   Saturate: '<S9>/Saturation'
  //   Sqrt: '<S9>/Sqrt'

  PX4_PID_B.aSinInput = PX4_PID_P.Gain_Gain_d * sqrt(PX4_PID_B.aSinInput) +
    PX4_PID_P.Constant1_Value_g;

  // Saturate: '<Root>/PWM Saturation'
  if (PX4_PID_B.aSinInput > PX4_PID_P.PWMSaturation_UpperSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.PWMSaturation_UpperSat;
  } else if (PX4_PID_B.aSinInput < PX4_PID_P.PWMSaturation_LowerSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.PWMSaturation_LowerSat;
  }

  // DataTypeConversion: '<Root>/Data Type Conversion' incorporates:
  //   Saturate: '<Root>/PWM Saturation'

  PX4_PID_B.u = floor(PX4_PID_B.aSinInput);
  if (rtIsNaN(PX4_PID_B.u) || rtIsInf(PX4_PID_B.u)) {
    PX4_PID_B.u = 0.0;
  } else {
    PX4_PID_B.u = fmod(PX4_PID_B.u, 65536.0);
  }

  // Sum: '<S9>/Sum1' incorporates:
  //   Gain: '<S9>/1//b'
  //   Sum: '<S9>/Sum10'

  PX4_PID_B.aSinInput = (PX4_PID_B.rtb_PWMSaturation_idx_1 +
    PX4_PID_B.rtb_PWMSaturation_idx_3) * PX4_PID_P.ub_Gain +
    PX4_PID_B.rtb_PWMSaturation_idx_0;

  // Saturate: '<S9>/Saturation'
  if (PX4_PID_B.aSinInput > PX4_PID_P.Saturation_UpperSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.Saturation_UpperSat;
  } else if (PX4_PID_B.aSinInput < PX4_PID_P.Saturation_LowerSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.Saturation_LowerSat;
  }

  // Sum: '<Root>/Sum1' incorporates:
  //   Constant: '<Root>/Constant1'
  //   Gain: '<Root>/Gain'
  //   Saturate: '<S9>/Saturation'
  //   Sqrt: '<S9>/Sqrt'

  PX4_PID_B.aSinInput = PX4_PID_P.Gain_Gain_d * sqrt(PX4_PID_B.aSinInput) +
    PX4_PID_P.Constant1_Value_g;

  // Saturate: '<Root>/PWM Saturation'
  if (PX4_PID_B.aSinInput > PX4_PID_P.PWMSaturation_UpperSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.PWMSaturation_UpperSat;
  } else if (PX4_PID_B.aSinInput < PX4_PID_P.PWMSaturation_LowerSat) {
    PX4_PID_B.aSinInput = PX4_PID_P.PWMSaturation_LowerSat;
  }

  // DataTypeConversion: '<Root>/Data Type Conversion' incorporates:
  //   Saturate: '<Root>/PWM Saturation'

  PX4_PID_B.rtb_PWMSaturation_idx_3 = floor(PX4_PID_B.aSinInput);
  if (rtIsNaN(PX4_PID_B.rtb_PWMSaturation_idx_3) || rtIsInf
      (PX4_PID_B.rtb_PWMSaturation_idx_3)) {
    PX4_PID_B.rtb_PWMSaturation_idx_3 = 0.0;
  } else {
    PX4_PID_B.rtb_PWMSaturation_idx_3 = fmod(PX4_PID_B.rtb_PWMSaturation_idx_3,
      65536.0);
  }

  // MATLABSystem: '<Root>/PX4 PWM Output' incorporates:
  //   DataTypeConversion: '<Root>/Data Type Conversion'

  for (sigIdx = 0; sigIdx < 8; sigIdx++) {
    PX4_PID_B.pwmValue[sigIdx] = 0U;
  }

  PX4_PID_B.pwmValue[0] = static_cast<uint16_T>
    (PX4_PID_B.rtb_PWMSaturation_idx_2 < 0.0 ? static_cast<int32_T>(static_cast<
      uint16_T>(-static_cast<int16_T>(static_cast<uint16_T>
        (-PX4_PID_B.rtb_PWMSaturation_idx_2)))) : static_cast<int32_T>(
      static_cast<uint16_T>(PX4_PID_B.rtb_PWMSaturation_idx_2)));
  PX4_PID_B.pwmValue[1] = static_cast<uint16_T>(PX4_PID_B.Gain_g < 0.0 ?
    static_cast<int32_T>(static_cast<uint16_T>(-static_cast<int16_T>(
    static_cast<uint16_T>(-PX4_PID_B.Gain_g)))) : static_cast<int32_T>(
    static_cast<uint16_T>(PX4_PID_B.Gain_g)));
  PX4_PID_B.pwmValue[2] = static_cast<uint16_T>(PX4_PID_B.u < 0.0 ?
    static_cast<int32_T>(static_cast<uint16_T>(-static_cast<int16_T>(
    static_cast<uint16_T>(-PX4_PID_B.u)))) : static_cast<int32_T>
    (static_cast<uint16_T>(PX4_PID_B.u)));
  PX4_PID_B.pwmValue[3] = static_cast<uint16_T>
    (PX4_PID_B.rtb_PWMSaturation_idx_3 < 0.0 ? static_cast<int32_T>
     (static_cast<uint16_T>(-static_cast<int16_T>(static_cast<uint16_T>
        (-PX4_PID_B.rtb_PWMSaturation_idx_3)))) : static_cast<int32_T>(
      static_cast<uint16_T>(PX4_PID_B.rtb_PWMSaturation_idx_3)));

  // Switch: '<Root>/switch' incorporates:
  //   Constant: '<Root>/Constant3'
  //   Constant: '<Root>/Constant4'

  if (PX4_PID_B.PROPOFS1[4] >= PX4_PID_P.switch_Threshold) {
    mask = PX4_PID_P.Constant3_Value;
  } else {
    mask = PX4_PID_P.Constant4_Value;
  }

  // MATLABSystem: '<Root>/PX4 PWM Output' incorporates:
  //   Constant: '<Root>/Constant5'
  //   Switch: '<Root>/switch'

  if (mask) {
    if (!PX4_PID_DW.obj.isArmed) {
      PX4_PID_DW.obj.isArmed = true;
      status = pwm_arm(&PX4_PID_DW.obj.pwmDevHandler,
                       &PX4_PID_DW.obj.armAdvertiseObj);
      PX4_PID_DW.obj.errorStatus = static_cast<uint16_T>
        (PX4_PID_DW.obj.errorStatus | status);
    }

    status = pwm_setServo(&PX4_PID_DW.obj.pwmDevHandler,
                          PX4_PID_DW.obj.servoCount, PX4_PID_DW.obj.channelMask,
                          &PX4_PID_B.pwmValue[0], PX4_PID_DW.obj.isMain,
                          &PX4_PID_DW.obj.actuatorAdvertiseObj);
    PX4_PID_DW.obj.errorStatus = static_cast<uint16_T>
      (PX4_PID_DW.obj.errorStatus | status);
  } else {
    status = pwm_disarm(&PX4_PID_DW.obj.pwmDevHandler,
                        &PX4_PID_DW.obj.armAdvertiseObj);
    PX4_PID_DW.obj.errorStatus = static_cast<uint16_T>
      (PX4_PID_DW.obj.errorStatus | status);
    PX4_PID_DW.obj.isArmed = false;
    status = pwm_resetServo(&PX4_PID_DW.obj.pwmDevHandler,
      PX4_PID_DW.obj.servoCount, PX4_PID_DW.obj.channelMask,
      PX4_PID_DW.obj.isMain, &PX4_PID_DW.obj.actuatorAdvertiseObj);
    PX4_PID_DW.obj.errorStatus = static_cast<uint16_T>
      (PX4_PID_DW.obj.errorStatus | status);
  }

  if (PX4_PID_DW.obj.isMain) {
    status = pwm_forceFailsafe(&PX4_PID_DW.obj.pwmDevHandler,
      static_cast<int32_T>(PX4_PID_P.Constant5_Value));
    PX4_PID_DW.obj.errorStatus = static_cast<uint16_T>
      (PX4_PID_DW.obj.errorStatus | status);
  }
}

// Use this function only if you need to maintain compatibility with an existing static main program.
void PX4_PID_step(int_T tid)
{
  switch (tid) {
   case 0 :
    PX4_PID_step0();
    break;

   case 1 :
    PX4_PID_step1();
    break;

   default :
    // do nothing
    break;
  }
}

// Model initialize function
void PX4_PID_initialize(void)
{
  // Registration code

  // initialize non-finites
  rt_InitInfAndNaN(sizeof(real_T));

  // non-finite (run-time) assignments
  PX4_PID_P.Saturation_UpperSat = rtInf;

  {
    boolean_T rtb_switch;

    // SystemInitialize for Enabled SubSystem: '<S160>/Enabled Subsystem'
    // SystemInitialize for SignalConversion generated from: '<S161>/In1' incorporates:
    //   Outport: '<S161>/Out1'

    PX4_PID_B.In1_i = PX4_PID_P.Out1_Y0_e;

    // End of SystemInitialize for SubSystem: '<S160>/Enabled Subsystem'

    // SystemInitialize for Enabled SubSystem: '<S162>/Enabled Subsystem'
    // SystemInitialize for SignalConversion generated from: '<S163>/In1' incorporates:
    //   Outport: '<S163>/Out1'

    PX4_PID_B.In1 = PX4_PID_P.Out1_Y0;

    // End of SystemInitialize for SubSystem: '<S162>/Enabled Subsystem'

    // Start for MATLABSystem: '<S3>/SourceBlock'
    PX4_PID_DW.obj_e.matlabCodegenIsDeleted = false;
    PX4_PID_DW.obj_e.isInitialized = 1;
    PX4_PID_DW.obj_e.orbMetadataObj = ORB_ID(actuator_armed);
    uORB_read_initialize(PX4_PID_DW.obj_e.orbMetadataObj,
                         &PX4_PID_DW.obj_e.eventStructObj);
    PX4_PID_DW.obj_e.isSetupComplete = true;
    PX4_PID_SourceBlock_Init(&PX4_PID_DW.SourceBlock_c);
    PX4_PID_SourceBlock_Init(&PX4_PID_DW.SourceBlock_n);

    // Start for MATLABSystem: '<S160>/SourceBlock'
    PX4_PID_DW.obj_g.matlabCodegenIsDeleted = false;
    PX4_PID_DW.obj_g.isInitialized = 1;
    PX4_PID_DW.obj_g.orbMetadataObj = ORB_ID(input_rc);
    uORB_read_initialize(PX4_PID_DW.obj_g.orbMetadataObj,
                         &PX4_PID_DW.obj_g.eventStructObj);
    PX4_PID_DW.obj_g.isSetupComplete = true;

    // Start for MATLABSystem: '<S162>/SourceBlock'
    PX4_PID_DW.obj_p.matlabCodegenIsDeleted = false;
    PX4_PID_DW.obj_p.isInitialized = 1;
    PX4_PID_DW.obj_p.orbMetadataObj = ORB_ID(vehicle_odometry);
    uORB_read_initialize(PX4_PID_DW.obj_p.orbMetadataObj,
                         &PX4_PID_DW.obj_p.eventStructObj);
    PX4_PID_DW.obj_p.isSetupComplete = true;

    // Start for MATLABSystem: '<Root>/PX4 PWM Output' incorporates:
    //   Constant: '<Root>/Constant5'

    PX4_PID_DW.obj.errorStatus = 0U;
    PX4_PID_DW.obj.isInitialized = 0;
    PX4_PID_DW.obj.matlabCodegenIsDeleted = false;
    PX4_PID_SystemCore_setup(&PX4_PID_DW.obj, rtb_switch,
      PX4_PID_P.Constant5_Value);
  }
}

// Model terminate function
void PX4_PID_terminate(void)
{
  uint16_T status;

  // Terminate for MATLABSystem: '<S3>/SourceBlock'
  if (!PX4_PID_DW.obj_e.matlabCodegenIsDeleted) {
    PX4_PID_DW.obj_e.matlabCodegenIsDeleted = true;
    if ((PX4_PID_DW.obj_e.isInitialized == 1) &&
        PX4_PID_DW.obj_e.isSetupComplete) {
      uORB_read_terminate(&PX4_PID_DW.obj_e.eventStructObj);
    }
  }

  // End of Terminate for MATLABSystem: '<S3>/SourceBlock'
  PX4_PID_SourceBlock_Term(&PX4_PID_DW.SourceBlock_c);
  PX4_PID_SourceBlock_Term(&PX4_PID_DW.SourceBlock_n);

  // Terminate for MATLABSystem: '<S160>/SourceBlock'
  if (!PX4_PID_DW.obj_g.matlabCodegenIsDeleted) {
    PX4_PID_DW.obj_g.matlabCodegenIsDeleted = true;
    if ((PX4_PID_DW.obj_g.isInitialized == 1) &&
        PX4_PID_DW.obj_g.isSetupComplete) {
      uORB_read_terminate(&PX4_PID_DW.obj_g.eventStructObj);
    }
  }

  // End of Terminate for MATLABSystem: '<S160>/SourceBlock'

  // Terminate for MATLABSystem: '<S162>/SourceBlock'
  if (!PX4_PID_DW.obj_p.matlabCodegenIsDeleted) {
    PX4_PID_DW.obj_p.matlabCodegenIsDeleted = true;
    if ((PX4_PID_DW.obj_p.isInitialized == 1) &&
        PX4_PID_DW.obj_p.isSetupComplete) {
      uORB_read_terminate(&PX4_PID_DW.obj_p.eventStructObj);
    }
  }

  // End of Terminate for MATLABSystem: '<S162>/SourceBlock'

  // Terminate for MATLABSystem: '<Root>/PX4 PWM Output'
  if (!PX4_PID_DW.obj.matlabCodegenIsDeleted) {
    PX4_PID_DW.obj.matlabCodegenIsDeleted = true;
    if ((PX4_PID_DW.obj.isInitialized == 1) && PX4_PID_DW.obj.isSetupComplete) {
      status = pwm_disarm(&PX4_PID_DW.obj.pwmDevHandler,
                          &PX4_PID_DW.obj.armAdvertiseObj);
      PX4_PID_DW.obj.errorStatus = static_cast<uint16_T>
        (PX4_PID_DW.obj.errorStatus | status);
      status = pwm_resetServo(&PX4_PID_DW.obj.pwmDevHandler,
        PX4_PID_DW.obj.servoCount, PX4_PID_DW.obj.channelMask,
        PX4_PID_DW.obj.isMain, &PX4_PID_DW.obj.actuatorAdvertiseObj);
      PX4_PID_DW.obj.errorStatus = static_cast<uint16_T>
        (PX4_PID_DW.obj.errorStatus | status);
      status = pwm_close(&PX4_PID_DW.obj.pwmDevHandler,
                         &PX4_PID_DW.obj.actuatorAdvertiseObj,
                         &PX4_PID_DW.obj.armAdvertiseObj);
      PX4_PID_DW.obj.errorStatus = static_cast<uint16_T>
        (PX4_PID_DW.obj.errorStatus | status);
    }
  }

  // End of Terminate for MATLABSystem: '<Root>/PX4 PWM Output'
}

//
// File trailer for generated code.
//
// [EOF]
//
