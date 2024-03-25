//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// File: direct_moter_input.cpp
//
// Code generated for Simulink model 'direct_moter_input'.
//
// Model version                  : 1.12
// Simulink Coder version         : 23.2 (R2023b) 01-Aug-2023
// C/C++ source code generated on : Thu Mar  7 13:13:05 2024
//
// Target selection: ert.tlc
// Embedded hardware selection: ARM Compatible->ARM Cortex
// Code generation objectives: Unspecified
// Validation result: Not run
//
#include "direct_moter_input.h"
#include "direct_moter_input_types.h"
#include "rtwtypes.h"
#include <math.h>

extern "C"
{

#include "rt_nonfinite.h"

}

#include "direct_moter_input_private.h"

// Block signals (default storage)
B_direct_moter_input_T direct_moter_input_B;

// Block states (default storage)
DW_direct_moter_input_T direct_moter_input_DW;

// Real-time model
RT_MODEL_direct_moter_input_T direct_moter_input_M_ =
  RT_MODEL_direct_moter_input_T();
RT_MODEL_direct_moter_input_T *const direct_moter_input_M =
  &direct_moter_input_M_;

// Forward declaration for local functions
static void direct_moter_i_SystemCore_setup(px4_internal_block_PWM_direct_T *obj,
  boolean_T varargin_1, boolean_T varargin_2);
static void direct_moter_i_SystemCore_setup(px4_internal_block_PWM_direct_T *obj,
  boolean_T varargin_1, boolean_T varargin_2)
{
  uint16_T status;
  obj->isSetupComplete = false;

  // Start for MATLABSystem: '<Root>/PX4 PWM Output'
  obj->isInitialized = 1;
  obj->isMain = true;
  obj->pwmDevObj = MW_PWM_OUTPUT_MAIN_DEVICE_PATH;
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

// Model step function
void direct_moter_input_step(void)
{
  real_T tmp_0;
  real_T tmp_1;
  real_T tmp_2;
  real_T tmp_3;
  int32_T i;
  uint16_T pwmValue[8];
  uint16_T status;
  uint16_T u1;
  boolean_T b_varargout_1;
  boolean_T tmp;

  // MATLABSystem: '<S4>/SourceBlock'
  b_varargout_1 = uORB_read_step(direct_moter_input_DW.obj_l.orbMetadataObj,
    &direct_moter_input_DW.obj_l.eventStructObj,
    &direct_moter_input_B.b_varargout_2, false, 5000.0);

  // Outputs for Enabled SubSystem: '<S4>/Enabled Subsystem' incorporates:
  //   EnablePort: '<S5>/Enable'

  // Start for MATLABSystem: '<S4>/SourceBlock'
  if (b_varargout_1) {
    // SignalConversion generated from: '<S5>/In1'
    direct_moter_input_B.In1 = direct_moter_input_B.b_varargout_2;
  }

  // End of Outputs for SubSystem: '<S4>/Enabled Subsystem'

  // MinMax: '<S3>/Min'
  status = direct_moter_input_B.In1.values[0];
  for (i = 0; i < 7; i++) {
    u1 = direct_moter_input_B.In1.values[i + 1];
    if (status > u1) {
      status = u1;
    }
  }

  // Switch: '<S3>/PROPO FS' incorporates:
  //   Constant: '<S3>/Constant2'
  //   Constant: '<S3>/Constant3'
  //   DataTypeConversion: '<S2>/Data Type Conversion'
  //   DataTypeConversion: '<S2>/Data Type Conversion1'
  //   DataTypeConversion: '<S2>/Data Type Conversion2'
  //   Gain: '<S2>/Gain'
  //   Gain: '<S2>/Gain1'
  //   Logic: '<S4>/NOT'
  //   MATLABSystem: '<S4>/SourceBlock'
  //   S-Function (sfix_bitop): '<S2>/Bitwise Operator'
  //
  if ((static_cast<int32_T>((static_cast<uint32_T>
         (direct_moter_input_P.Gain_Gain) * direct_moter_input_B.In1.rc_failsafe)
        >> 6) | static_cast<int32_T>(!b_varargout_1) | static_cast<int32_T>((
         static_cast<uint32_T>(direct_moter_input_P.Gain1_Gain) *
         direct_moter_input_B.In1.rc_lost) >> 5)) >=
      direct_moter_input_P.PROPOFS_Threshold) {
    b_varargout_1 = direct_moter_input_P.Constant2_Value;
  } else {
    b_varargout_1 = direct_moter_input_P.Constant3_Value;
  }

  // Switch: '<S3>/Signal FS' incorporates:
  //   Constant: '<S3>/Constant2'
  //   Constant: '<S3>/Constant3'
  //   MinMax: '<S3>/Min'

  if (status >= direct_moter_input_P.SignalFS_Threshold) {
    tmp = direct_moter_input_P.Constant3_Value;
  } else {
    tmp = direct_moter_input_P.Constant2_Value;
  }

  // Switch: '<S3>/PROPO FS1' incorporates:
  //   Constant: '<S3>/Constant'
  //   Logic: '<S3>/OR'
  //   Switch: '<S3>/PROPO FS'
  //   Switch: '<S3>/Signal FS'

  if (b_varargout_1 || tmp) {
    direct_moter_input_B.PROPOFS1[2] = direct_moter_input_P.Constant_Value_n;
    direct_moter_input_B.PROPOFS1[4] = direct_moter_input_P.Constant_Value_n;
  } else {
    for (i = 0; i < 8; i++) {
      // Saturate: '<S3>/Saturation'
      status = direct_moter_input_B.In1.values[i];
      if (status > direct_moter_input_P.Saturation_UpperSat) {
        direct_moter_input_B.PROPOFS1[i] =
          direct_moter_input_P.Saturation_UpperSat;
      } else if (status < direct_moter_input_P.Saturation_LowerSat) {
        direct_moter_input_B.PROPOFS1[i] =
          direct_moter_input_P.Saturation_LowerSat;
      } else {
        direct_moter_input_B.PROPOFS1[i] = status;
      }

      // End of Saturate: '<S3>/Saturation'
    }
  }

  // End of Switch: '<S3>/PROPO FS1'

  // Saturate: '<Root>/PWM Saturation'
  if (direct_moter_input_B.PROPOFS1[2] >
      direct_moter_input_P.PWMSaturation_UpperSat) {
    tmp_0 = direct_moter_input_P.PWMSaturation_UpperSat;
  } else if (direct_moter_input_B.PROPOFS1[2] <
             direct_moter_input_P.PWMSaturation_LowerSat) {
    tmp_0 = direct_moter_input_P.PWMSaturation_LowerSat;
  } else {
    tmp_0 = direct_moter_input_B.PROPOFS1[2];
  }

  // DataTypeConversion: '<Root>/Data Type Conversion' incorporates:
  //   Saturate: '<Root>/PWM Saturation'

  tmp_0 = floor(tmp_0);
  if (rtIsNaN(tmp_0) || rtIsInf(tmp_0)) {
    tmp_0 = 0.0;
  } else {
    tmp_0 = fmod(tmp_0, 65536.0);
  }

  // Saturate: '<Root>/PWM Saturation'
  if (direct_moter_input_B.PROPOFS1[2] >
      direct_moter_input_P.PWMSaturation_UpperSat) {
    tmp_1 = direct_moter_input_P.PWMSaturation_UpperSat;
  } else if (direct_moter_input_B.PROPOFS1[2] <
             direct_moter_input_P.PWMSaturation_LowerSat) {
    tmp_1 = direct_moter_input_P.PWMSaturation_LowerSat;
  } else {
    tmp_1 = direct_moter_input_B.PROPOFS1[2];
  }

  // DataTypeConversion: '<Root>/Data Type Conversion' incorporates:
  //   Saturate: '<Root>/PWM Saturation'

  tmp_1 = floor(tmp_1);
  if (rtIsNaN(tmp_1) || rtIsInf(tmp_1)) {
    tmp_1 = 0.0;
  } else {
    tmp_1 = fmod(tmp_1, 65536.0);
  }

  // Saturate: '<Root>/PWM Saturation'
  if (direct_moter_input_B.PROPOFS1[2] >
      direct_moter_input_P.PWMSaturation_UpperSat) {
    tmp_2 = direct_moter_input_P.PWMSaturation_UpperSat;
  } else if (direct_moter_input_B.PROPOFS1[2] <
             direct_moter_input_P.PWMSaturation_LowerSat) {
    tmp_2 = direct_moter_input_P.PWMSaturation_LowerSat;
  } else {
    tmp_2 = direct_moter_input_B.PROPOFS1[2];
  }

  // DataTypeConversion: '<Root>/Data Type Conversion' incorporates:
  //   Saturate: '<Root>/PWM Saturation'

  tmp_2 = floor(tmp_2);
  if (rtIsNaN(tmp_2) || rtIsInf(tmp_2)) {
    tmp_2 = 0.0;
  } else {
    tmp_2 = fmod(tmp_2, 65536.0);
  }

  // Saturate: '<Root>/PWM Saturation'
  if (direct_moter_input_B.PROPOFS1[2] >
      direct_moter_input_P.PWMSaturation_UpperSat) {
    tmp_3 = direct_moter_input_P.PWMSaturation_UpperSat;
  } else if (direct_moter_input_B.PROPOFS1[2] <
             direct_moter_input_P.PWMSaturation_LowerSat) {
    tmp_3 = direct_moter_input_P.PWMSaturation_LowerSat;
  } else {
    tmp_3 = direct_moter_input_B.PROPOFS1[2];
  }

  // DataTypeConversion: '<Root>/Data Type Conversion' incorporates:
  //   Saturate: '<Root>/PWM Saturation'

  tmp_3 = floor(tmp_3);
  if (rtIsNaN(tmp_3) || rtIsInf(tmp_3)) {
    tmp_3 = 0.0;
  } else {
    tmp_3 = fmod(tmp_3, 65536.0);
  }

  // MATLABSystem: '<Root>/PX4 PWM Output' incorporates:
  //   Constant: '<Root>/Constant5'
  //   DataTypeConversion: '<Root>/Data Type Conversion'
  //   MATLAB Function: '<Root>/MATLAB Function'

  for (i = 0; i < 8; i++) {
    pwmValue[i] = 0U;
  }

  pwmValue[0] = static_cast<uint16_T>(tmp_0 < 0.0 ? static_cast<int32_T>(
    static_cast<uint16_T>(-static_cast<int16_T>(static_cast<uint16_T>(-tmp_0))))
    : static_cast<int32_T>(static_cast<uint16_T>(tmp_0)));
  pwmValue[1] = static_cast<uint16_T>(tmp_1 < 0.0 ? static_cast<int32_T>(
    static_cast<uint16_T>(-static_cast<int16_T>(static_cast<uint16_T>(-tmp_1))))
    : static_cast<int32_T>(static_cast<uint16_T>(tmp_1)));
  pwmValue[2] = static_cast<uint16_T>(tmp_2 < 0.0 ? static_cast<int32_T>(
    static_cast<uint16_T>(-static_cast<int16_T>(static_cast<uint16_T>(-tmp_2))))
    : static_cast<int32_T>(static_cast<uint16_T>(tmp_2)));
  pwmValue[3] = static_cast<uint16_T>(tmp_3 < 0.0 ? static_cast<int32_T>(
    static_cast<uint16_T>(-static_cast<int16_T>(static_cast<uint16_T>(-tmp_3))))
    : static_cast<int32_T>(static_cast<uint16_T>(tmp_3)));
  if (direct_moter_input_B.PROPOFS1[4] >= 1500.0) {
    if (!direct_moter_input_DW.obj.isArmed) {
      direct_moter_input_DW.obj.isArmed = true;
      status = pwm_arm(&direct_moter_input_DW.obj.pwmDevHandler,
                       &direct_moter_input_DW.obj.armAdvertiseObj);
      direct_moter_input_DW.obj.errorStatus = static_cast<uint16_T>
        (direct_moter_input_DW.obj.errorStatus | status);
    }

    status = pwm_setServo(&direct_moter_input_DW.obj.pwmDevHandler,
                          direct_moter_input_DW.obj.servoCount,
                          direct_moter_input_DW.obj.channelMask, &pwmValue[0],
                          direct_moter_input_DW.obj.isMain,
                          &direct_moter_input_DW.obj.actuatorAdvertiseObj);
    direct_moter_input_DW.obj.errorStatus = static_cast<uint16_T>
      (direct_moter_input_DW.obj.errorStatus | status);
  } else {
    status = pwm_disarm(&direct_moter_input_DW.obj.pwmDevHandler,
                        &direct_moter_input_DW.obj.armAdvertiseObj);
    direct_moter_input_DW.obj.errorStatus = static_cast<uint16_T>
      (direct_moter_input_DW.obj.errorStatus | status);
    direct_moter_input_DW.obj.isArmed = false;
    status = pwm_resetServo(&direct_moter_input_DW.obj.pwmDevHandler,
      direct_moter_input_DW.obj.servoCount,
      direct_moter_input_DW.obj.channelMask, direct_moter_input_DW.obj.isMain,
      &direct_moter_input_DW.obj.actuatorAdvertiseObj);
    direct_moter_input_DW.obj.errorStatus = static_cast<uint16_T>
      (direct_moter_input_DW.obj.errorStatus | status);
  }

  if (direct_moter_input_DW.obj.isMain) {
    status = pwm_forceFailsafe(&direct_moter_input_DW.obj.pwmDevHandler,
      static_cast<int32_T>(direct_moter_input_P.Constant5_Value));
    direct_moter_input_DW.obj.errorStatus = static_cast<uint16_T>
      (direct_moter_input_DW.obj.errorStatus | status);
  }

  // End of MATLABSystem: '<Root>/PX4 PWM Output'
}

// Model initialize function
void direct_moter_input_initialize(void)
{
  // Registration code

  // initialize non-finites
  rt_InitInfAndNaN(sizeof(real_T));

  {
    boolean_T rtb_y;

    // SystemInitialize for Enabled SubSystem: '<S4>/Enabled Subsystem'
    // SystemInitialize for SignalConversion generated from: '<S5>/In1' incorporates:
    //   Outport: '<S5>/Out1'

    direct_moter_input_B.In1 = direct_moter_input_P.Out1_Y0;

    // End of SystemInitialize for SubSystem: '<S4>/Enabled Subsystem'

    // Start for MATLABSystem: '<S4>/SourceBlock'
    direct_moter_input_DW.obj_l.matlabCodegenIsDeleted = false;
    direct_moter_input_DW.obj_l.isInitialized = 1;
    direct_moter_input_DW.obj_l.orbMetadataObj = ORB_ID(input_rc);
    uORB_read_initialize(direct_moter_input_DW.obj_l.orbMetadataObj,
                         &direct_moter_input_DW.obj_l.eventStructObj);
    direct_moter_input_DW.obj_l.isSetupComplete = true;

    // Start for MATLABSystem: '<Root>/PX4 PWM Output' incorporates:
    //   Constant: '<Root>/Constant5'

    direct_moter_input_DW.obj.errorStatus = 0U;
    direct_moter_input_DW.obj.isInitialized = 0;
    direct_moter_input_DW.obj.matlabCodegenIsDeleted = false;
    direct_moter_i_SystemCore_setup(&direct_moter_input_DW.obj, rtb_y,
      direct_moter_input_P.Constant5_Value);
  }
}

// Model terminate function
void direct_moter_input_terminate(void)
{
  // Terminate for MATLABSystem: '<S4>/SourceBlock'
  if (!direct_moter_input_DW.obj_l.matlabCodegenIsDeleted) {
    direct_moter_input_DW.obj_l.matlabCodegenIsDeleted = true;
    if ((direct_moter_input_DW.obj_l.isInitialized == 1) &&
        direct_moter_input_DW.obj_l.isSetupComplete) {
      uORB_read_terminate(&direct_moter_input_DW.obj_l.eventStructObj);
    }
  }

  // End of Terminate for MATLABSystem: '<S4>/SourceBlock'

  // Terminate for MATLABSystem: '<Root>/PX4 PWM Output'
  if (!direct_moter_input_DW.obj.matlabCodegenIsDeleted) {
    direct_moter_input_DW.obj.matlabCodegenIsDeleted = true;
    if ((direct_moter_input_DW.obj.isInitialized == 1) &&
        direct_moter_input_DW.obj.isSetupComplete) {
      uint16_T status;
      status = pwm_disarm(&direct_moter_input_DW.obj.pwmDevHandler,
                          &direct_moter_input_DW.obj.armAdvertiseObj);
      direct_moter_input_DW.obj.errorStatus = static_cast<uint16_T>
        (direct_moter_input_DW.obj.errorStatus | status);
      status = pwm_resetServo(&direct_moter_input_DW.obj.pwmDevHandler,
        direct_moter_input_DW.obj.servoCount,
        direct_moter_input_DW.obj.channelMask, direct_moter_input_DW.obj.isMain,
        &direct_moter_input_DW.obj.actuatorAdvertiseObj);
      direct_moter_input_DW.obj.errorStatus = static_cast<uint16_T>
        (direct_moter_input_DW.obj.errorStatus | status);
      status = pwm_close(&direct_moter_input_DW.obj.pwmDevHandler,
                         &direct_moter_input_DW.obj.actuatorAdvertiseObj,
                         &direct_moter_input_DW.obj.armAdvertiseObj);
      direct_moter_input_DW.obj.errorStatus = static_cast<uint16_T>
        (direct_moter_input_DW.obj.errorStatus | status);
    }
  }

  // End of Terminate for MATLABSystem: '<Root>/PX4 PWM Output'
}

//
// File trailer for generated code.
//
// [EOF]
//
