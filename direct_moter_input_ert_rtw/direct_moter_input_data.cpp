//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// File: direct_moter_input_data.cpp
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

// Block parameters (default storage)
P_direct_moter_input_T direct_moter_input_P = {
  // Computed Parameter: Out1_Y0
  //  Referenced by: '<S5>/Out1'

  {
    (0ULL),                            // timestamp
    (0ULL),                            // timestamp_last_signal
    0,                                 // rssi
    0U,                                // rc_lost_frame_count
    0U,                                // rc_total_frame_count
    0U,                                // rc_ppm_frame_length

    {
      0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U }
    ,                                  // values
    0U,                                // channel_count
    false,                             // rc_failsafe
    false,                             // rc_lost
    0U,                                // input_source

    {
      0U, 0U, 0U, 0U, 0U, 0U }
    // _padding0
  },

  // Computed Parameter: Constant_Value
  //  Referenced by: '<S4>/Constant'

  {
    (0ULL),                            // timestamp
    (0ULL),                            // timestamp_last_signal
    0,                                 // rssi
    0U,                                // rc_lost_frame_count
    0U,                                // rc_total_frame_count
    0U,                                // rc_ppm_frame_length

    {
      0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U }
    ,                                  // values
    0U,                                // channel_count
    false,                             // rc_failsafe
    false,                             // rc_lost
    0U,                                // input_source

    {
      0U, 0U, 0U, 0U, 0U, 0U }
    // _padding0
  },

  // Expression: 1500
  //  Referenced by: '<S3>/Constant1'

  1500.0,

  // Expression: 1000
  //  Referenced by: '<S3>/Constant'

  1000.0,

  // Expression: 2000
  //  Referenced by: '<Root>/PWM Saturation'

  2000.0,

  // Expression: 1000
  //  Referenced by: '<Root>/PWM Saturation'

  1000.0,

  // Computed Parameter: Saturation_UpperSat
  //  Referenced by: '<S3>/Saturation'

  2000U,

  // Computed Parameter: Saturation_LowerSat
  //  Referenced by: '<S3>/Saturation'

  1000U,

  // Computed Parameter: SignalFS_Threshold
  //  Referenced by: '<S3>/Signal FS'

  900U,

  // Computed Parameter: Constant2_Value
  //  Referenced by: '<S3>/Constant2'

  true,

  // Computed Parameter: Constant3_Value
  //  Referenced by: '<S3>/Constant3'

  false,

  // Computed Parameter: Constant5_Value
  //  Referenced by: '<Root>/Constant5'

  false,

  // Computed Parameter: Gain1_Gain
  //  Referenced by: '<S2>/Gain1'

  128U,

  // Computed Parameter: Gain_Gain
  //  Referenced by: '<S2>/Gain'

  128U,

  // Computed Parameter: PROPOFS_Threshold
  //  Referenced by: '<S3>/PROPO FS'

  2U
};

//
// File trailer for generated code.
//
// [EOF]
//
