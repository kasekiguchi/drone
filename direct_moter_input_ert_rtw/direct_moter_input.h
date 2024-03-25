//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// File: direct_moter_input.h
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
#ifndef RTW_HEADER_direct_moter_input_h_
#define RTW_HEADER_direct_moter_input_h_
#include <poll.h>
#include <uORB/uORB.h>
#include "rtwtypes.h"
#include "MW_PX4_PWM.h"
#include "MW_uORB_Read.h"
#include "direct_moter_input_types.h"
#include <uORB/topics/input_rc.h>

extern "C"
{

#include "rt_nonfinite.h"

}

#include <stddef.h>

// Macros for accessing real-time model data structure
#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

// Block signals (default storage)
struct B_direct_moter_input_T {
  px4_Bus_input_rc In1;                // '<S5>/In1'
  px4_Bus_input_rc b_varargout_2;
  real_T PROPOFS1[8];                  // '<S3>/PROPO FS1'
};

// Block states (default storage) for system '<Root>'
struct DW_direct_moter_input_T {
  px4_internal_block_PWM_direct_T obj; // '<Root>/PX4 PWM Output'
  px4_internal_block_Subscriber_T obj_l;// '<S4>/SourceBlock'
};

// Parameters (default storage)
struct P_direct_moter_input_T_ {
  px4_Bus_input_rc Out1_Y0;            // Computed Parameter: Out1_Y0
                                          //  Referenced by: '<S5>/Out1'

  px4_Bus_input_rc Constant_Value;     // Computed Parameter: Constant_Value
                                          //  Referenced by: '<S4>/Constant'

  real_T Constant1_Value;              // Expression: 1500
                                          //  Referenced by: '<S3>/Constant1'

  real_T Constant_Value_n;             // Expression: 1000
                                          //  Referenced by: '<S3>/Constant'

  real_T PWMSaturation_UpperSat;       // Expression: 2000
                                          //  Referenced by: '<Root>/PWM Saturation'

  real_T PWMSaturation_LowerSat;       // Expression: 1000
                                          //  Referenced by: '<Root>/PWM Saturation'

  uint16_T Saturation_UpperSat;       // Computed Parameter: Saturation_UpperSat
                                         //  Referenced by: '<S3>/Saturation'

  uint16_T Saturation_LowerSat;       // Computed Parameter: Saturation_LowerSat
                                         //  Referenced by: '<S3>/Saturation'

  uint16_T SignalFS_Threshold;         // Computed Parameter: SignalFS_Threshold
                                          //  Referenced by: '<S3>/Signal FS'

  boolean_T Constant2_Value;           // Computed Parameter: Constant2_Value
                                          //  Referenced by: '<S3>/Constant2'

  boolean_T Constant3_Value;           // Computed Parameter: Constant3_Value
                                          //  Referenced by: '<S3>/Constant3'

  boolean_T Constant5_Value;           // Computed Parameter: Constant5_Value
                                          //  Referenced by: '<Root>/Constant5'

  uint8_T Gain1_Gain;                  // Computed Parameter: Gain1_Gain
                                          //  Referenced by: '<S2>/Gain1'

  uint8_T Gain_Gain;                   // Computed Parameter: Gain_Gain
                                          //  Referenced by: '<S2>/Gain'

  uint8_T PROPOFS_Threshold;           // Computed Parameter: PROPOFS_Threshold
                                          //  Referenced by: '<S3>/PROPO FS'

};

// Real-time Model Data Structure
struct tag_RTM_direct_moter_input_T {
  const char_T * volatile errorStatus;
};

// Block parameters (default storage)
#ifdef __cplusplus

extern "C"
{

#endif

  extern P_direct_moter_input_T direct_moter_input_P;

#ifdef __cplusplus

}

#endif

// Block signals (default storage)
#ifdef __cplusplus

extern "C"
{

#endif

  extern struct B_direct_moter_input_T direct_moter_input_B;

#ifdef __cplusplus

}

#endif

// Block states (default storage)
extern struct DW_direct_moter_input_T direct_moter_input_DW;

#ifdef __cplusplus

extern "C"
{

#endif

  // Model entry point functions
  extern void direct_moter_input_initialize(void);
  extern void direct_moter_input_step(void);
  extern void direct_moter_input_terminate(void);

#ifdef __cplusplus

}

#endif

// Real-time Model object
#ifdef __cplusplus

extern "C"
{

#endif

  extern RT_MODEL_direct_moter_input_T *const direct_moter_input_M;

#ifdef __cplusplus

}

#endif

extern volatile boolean_T stopRequested;
extern volatile boolean_T runModel;

//-
//  These blocks were eliminated from the model due to optimizations:
//
//  Block '<Root>/Display' : Unused code path elimination
//  Block '<Root>/Display1' : Unused code path elimination
//  Block '<Root>/Display2' : Unused code path elimination
//  Block '<Root>/Display3' : Unused code path elimination
//  Block '<Root>/Display4' : Unused code path elimination


//-
//  The generated code includes comments that allow you to trace directly
//  back to the appropriate location in the model.  The basic format
//  is <system>/block_name, where system is the system number (uniquely
//  assigned by Simulink) and block_name is the name of the block.
//
//  Use the MATLAB hilite_system command to trace the generated code back
//  to the model.  For example,
//
//  hilite_system('<S3>')    - opens system 3
//  hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
//
//  Here is the system hierarchy for this model
//
//  '<Root>' : 'direct_moter_input'
//  '<S1>'   : 'direct_moter_input/MATLAB Function'
//  '<S2>'   : 'direct_moter_input/Radio Control Transmitter1'
//  '<S3>'   : 'direct_moter_input/Subsystem'
//  '<S4>'   : 'direct_moter_input/Radio Control Transmitter1/PX4 uORB Read'
//  '<S5>'   : 'direct_moter_input/Radio Control Transmitter1/PX4 uORB Read/Enabled Subsystem'

#endif                                 // RTW_HEADER_direct_moter_input_h_

//
// File trailer for generated code.
//
// [EOF]
//
