//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// File: PX4_PID_data.cpp
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

// Block parameters (default storage)
P_PX4_PID_T PX4_PID_P = {
  // Mask Parameter: RollPID_P
  //  Referenced by: '<S97>/Proportional Gain'

  1.0,

  // Mask Parameter: PitchPID_P
  //  Referenced by: '<S49>/Proportional Gain'

  1.0,

  // Mask Parameter: YawPID_P
  //  Referenced by: '<S145>/Proportional Gain'

  1.0,

  // Computed Parameter: Out1_Y0
  //  Referenced by: '<S163>/Out1'

  {
    (0ULL),                            // timestamp
    (0ULL),                            // timestamp_sample
    0.0F,                              // x
    0.0F,                              // y
    0.0F,                              // z

    {
      0.0F, 0.0F, 0.0F, 0.0F }
    ,                                  // q

    {
      0.0F, 0.0F, 0.0F, 0.0F }
    ,                                  // q_offset

    {
      0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F,
      0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F }
    ,                                  // pose_covariance
    0.0F,                              // vx
    0.0F,                              // vy
    0.0F,                              // vz
    0.0F,                              // rollspeed
    0.0F,                              // pitchspeed
    0.0F,                              // yawspeed

    {
      0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F,
      0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F }
    ,                                  // velocity_covariance
    0U,                                // local_frame
    0U,                                // velocity_frame

    {
      0U, 0U }
    // _padding0
  },

  // Computed Parameter: Constant_Value
  //  Referenced by: '<S162>/Constant'

  {
    (0ULL),                            // timestamp
    (0ULL),                            // timestamp_sample
    0.0F,                              // x
    0.0F,                              // y
    0.0F,                              // z

    {
      0.0F, 0.0F, 0.0F, 0.0F }
    ,                                  // q

    {
      0.0F, 0.0F, 0.0F, 0.0F }
    ,                                  // q_offset

    {
      0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F,
      0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F }
    ,                                  // pose_covariance
    0.0F,                              // vx
    0.0F,                              // vy
    0.0F,                              // vz
    0.0F,                              // rollspeed
    0.0F,                              // pitchspeed
    0.0F,                              // yawspeed

    {
      0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F,
      0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F }
    ,                                  // velocity_covariance
    0U,                                // local_frame
    0U,                                // velocity_frame

    {
      0U, 0U }
    // _padding0
  },

  // Computed Parameter: Out1_Y0_e
  //  Referenced by: '<S161>/Out1'

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

  // Computed Parameter: Constant_Value_h
  //  Referenced by: '<S160>/Constant'

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

  // Computed Parameter: Out1_Y0_j
  //  Referenced by: '<S158>/Out1'

  {
    (0ULL),                            // timestamp
    0U,                                // esc_errorcount
    0,                                 // esc_rpm
    0.0F,                              // esc_voltage
    0.0F,                              // esc_current
    0U,                                // esc_temperature
    0U,                                // esc_address
    0U,                                // esc_state
    0U,                                // failures

    {
      0U, 0U, 0U, 0U }
    // _padding0
  },

  // Computed Parameter: Out1_Y0_jd
  //  Referenced by: '<S159>/Out1'

  {
    (0ULL),                            // timestamp
    0U,                                // esc_errorcount
    0,                                 // esc_rpm
    0.0F,                              // esc_voltage
    0.0F,                              // esc_current
    0U,                                // esc_temperature
    0U,                                // esc_address
    0U,                                // esc_state
    0U,                                // failures

    {
      0U, 0U, 0U, 0U }
    // _padding0
  },

  // Computed Parameter: Constant_Value_l
  //  Referenced by: '<S4>/Constant'

  {
    (0ULL),                            // timestamp
    0U,                                // esc_errorcount
    0,                                 // esc_rpm
    0.0F,                              // esc_voltage
    0.0F,                              // esc_current
    0U,                                // esc_temperature
    0U,                                // esc_address
    0U,                                // esc_state
    0U,                                // failures

    {
      0U, 0U, 0U, 0U }
    // _padding0
  },

  // Computed Parameter: Constant_Value_d
  //  Referenced by: '<S5>/Constant'

  {
    (0ULL),                            // timestamp
    0U,                                // esc_errorcount
    0,                                 // esc_rpm
    0.0F,                              // esc_voltage
    0.0F,                              // esc_current
    0U,                                // esc_temperature
    0U,                                // esc_address
    0U,                                // esc_state
    0U,                                // failures

    {
      0U, 0U, 0U, 0U }
    // _padding0
  },

  // Computed Parameter: Out1_Y0_jc
  //  Referenced by: '<S157>/Out1'

  {
    (0ULL),                            // timestamp
    false,                             // armed
    false,                             // prearmed
    false,                             // ready_to_arm
    false,                             // lockdown
    false,                             // manual_lockdown
    false,                             // force_failsafe
    false,                             // in_esc_calibration_mode
    false                              // soft_stop
  },

  // Computed Parameter: Constant_Value_m
  //  Referenced by: '<S3>/Constant'

  {
    (0ULL),                            // timestamp
    false,                             // armed
    false,                             // prearmed
    false,                             // ready_to_arm
    false,                             // lockdown
    false,                             // manual_lockdown
    false,                             // force_failsafe
    false,                             // in_esc_calibration_mode
    false                              // soft_stop
  },

  // Expression: 1500
  //  Referenced by: '<S7>/Constant1'

  1500.0,

  // Expression: 1000
  //  Referenced by: '<S7>/Constant'

  1000.0,

  // Expression: -1
  //  Referenced by: '<S2>/Gain1'

  -1.0,

  // Expression: 1000
  //  Referenced by: '<Root>/Constant2'

  1000.0,

  // Expression: 1
  //  Referenced by: '<Root>/Gain1'

  1.0,

  // Expression: 1/4
  //  Referenced by: '<S9>/Gain'

  0.25,

  // Expression: 1500
  //  Referenced by: '<Root>/Constant'

  1500.0,

  // Expression: 1/500
  //  Referenced by: '<Root>/Gain5'

  0.002,

  // Expression: 1/0.3
  //  Referenced by: '<S9>/1//L'

  3.3333333333333335,

  // Expression: 0.5
  //  Referenced by: '<S9>/•ª”z'

  0.5,

  // Expression: 1/0.3
  //  Referenced by: '<S9>/1//L''

  3.3333333333333335,

  // Expression: 0.5
  //  Referenced by: '<S9>/•ª”z1'

  0.5,

  // Expression: 1/1e-6
  //  Referenced by: '<S9>/1//b'

  1.0E+6,

  // Expression: 1/1.140e-7
  //  Referenced by: '<S9>/1//k'

  8.7719298245614041E+6,

  // Expression: 1/4
  //  Referenced by: '<S9>/Gain2'

  0.25,

  // Expression: -1
  //  Referenced by: '<S9>/Gain3'

  -1.0,

  // Expression: -1
  //  Referenced by: '<S9>/Gain4'

  -1.0,

  // Expression: inf
  //  Referenced by: '<S9>/Saturation'

  0.0,

  // Expression: 0
  //  Referenced by: '<S9>/Saturation'

  0.0,

  // Expression: 1/30
  //  Referenced by: '<Root>/Gain'

  0.033333333333333333,

  // Expression: 1000
  //  Referenced by: '<Root>/Constant1'

  1000.0,

  // Expression: 2000
  //  Referenced by: '<Root>/PWM Saturation'

  2000.0,

  // Expression: 1000
  //  Referenced by: '<Root>/PWM Saturation'

  1000.0,

  // Expression: 1500
  //  Referenced by: '<Root>/switch'

  1500.0,

  // Computed Parameter: Gain2_Gain_l
  //  Referenced by: '<S2>/Gain2'

  -1.0F,

  // Computed Parameter: Saturation_UpperSat_o
  //  Referenced by: '<S7>/Saturation'

  2000U,

  // Computed Parameter: Saturation_LowerSat_p
  //  Referenced by: '<S7>/Saturation'

  1000U,

  // Computed Parameter: SignalFS_Threshold
  //  Referenced by: '<S7>/Signal FS'

  900U,

  // Computed Parameter: Constant3_Value
  //  Referenced by: '<Root>/Constant3'

  true,

  // Computed Parameter: Constant4_Value
  //  Referenced by: '<Root>/Constant4'

  false,

  // Computed Parameter: Constant2_Value_l
  //  Referenced by: '<S7>/Constant2'

  true,

  // Computed Parameter: Constant3_Value_m
  //  Referenced by: '<S7>/Constant3'

  false,

  // Computed Parameter: Constant5_Value
  //  Referenced by: '<Root>/Constant5'

  false,

  // Computed Parameter: Gain1_Gain_n
  //  Referenced by: '<S6>/Gain1'

  128U,

  // Computed Parameter: Gain_Gain_k
  //  Referenced by: '<S6>/Gain'

  128U,

  // Computed Parameter: PROPOFS_Threshold
  //  Referenced by: '<S7>/PROPO FS'

  2U
};

//
// File trailer for generated code.
//
// [EOF]
//
