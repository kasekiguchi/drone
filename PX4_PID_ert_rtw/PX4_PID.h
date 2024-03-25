//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// File: PX4_PID.h
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
#ifndef RTW_HEADER_PX4_PID_h_
#define RTW_HEADER_PX4_PID_h_
#include <poll.h>
#include <uORB/uORB.h>
#include "rtwtypes.h"
#include "MW_PX4_PWM.h"
#include "MW_uORB_Read.h"
#include "PX4_PID_types.h"
#include <uORB/topics/esc_report.h>
#include <uORB/topics/vehicle_odometry.h>
#include <uORB/topics/input_rc.h>
#include <uORB/topics/actuator_armed.h>

extern "C"
{

#include "rt_nonfinite.h"

}

extern "C"
{

#include "rtGetNaN.h"

}

#include <stddef.h>

// Macros for accessing real-time model data structure
#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

#ifndef rtmStepTask
#define rtmStepTask(rtm, idx)          ((rtm)->Timing.TaskCounters.TID[(idx)] == 0)
#endif

#ifndef rtmTaskCounter
#define rtmTaskCounter(rtm, idx)       ((rtm)->Timing.TaskCounters.TID[(idx)])
#endif

// Block signals for system '<S4>/SourceBlock'
struct B_SourceBlock_PX4_PID_T {
  px4_Bus_esc_report SourceBlock_o2;   // '<S4>/SourceBlock'
  boolean_T SourceBlock_o1;            // '<S4>/SourceBlock'
};

// Block states (default storage) for system '<S4>/SourceBlock'
struct DW_SourceBlock_PX4_PID_T {
  px4_internal_block_Subscriber_T obj; // '<S4>/SourceBlock'
  boolean_T objisempty;                // '<S4>/SourceBlock'
};

// Block signals (default storage)
struct B_PX4_PID_T {
  px4_Bus_vehicle_odometry In1;        // '<S163>/In1'
  px4_Bus_vehicle_odometry b_varargout_2;
  px4_Bus_input_rc In1_i;              // '<S161>/In1'
  px4_Bus_input_rc b_varargout_2_m;
  real_T PROPOFS1[8];                  // '<S7>/PROPO FS1'
  real_T out[3];
  uint16_T pwmValue[8];
  real_T aSinInput;
  real_T j_data;
  real_T b_x_data;
  real_T Gain_g;                       // '<S9>/Gain'
  real_T u;                            // '<S9>/•ª”z'
  real_T rtb_PWMSaturation_data;
  real_T rtb_PWMSaturation_data_c;
  real_T rtb_PWMSaturation_idx_0;
  real_T rtb_PWMSaturation_idx_1;
  real_T rtb_PWMSaturation_idx_2;
  real_T rtb_PWMSaturation_idx_3;
  real_T out_tmp;
  real_T out_tmp_k;
  B_SourceBlock_PX4_PID_T SourceBlock_n;// '<S4>/SourceBlock'
  B_SourceBlock_PX4_PID_T SourceBlock_c;// '<S4>/SourceBlock'
};

// Block states (default storage) for system '<Root>'
struct DW_PX4_PID_T {
  px4_internal_block_PWM_PX4_PI_T obj; // '<Root>/PX4 PWM Output'
  px4_internal_block_Subscriber_T obj_p;// '<S162>/SourceBlock'
  px4_internal_block_Subscriber_T obj_g;// '<S160>/SourceBlock'
  px4_internal_block_Subscriber_T obj_e;// '<S3>/SourceBlock'
  DW_SourceBlock_PX4_PID_T SourceBlock_n;// '<S4>/SourceBlock'
  DW_SourceBlock_PX4_PID_T SourceBlock_c;// '<S4>/SourceBlock'
};

// Parameters (default storage)
struct P_PX4_PID_T_ {
  real_T RollPID_P;                    // Mask Parameter: RollPID_P
                                          //  Referenced by: '<S97>/Proportional Gain'

  real_T PitchPID_P;                   // Mask Parameter: PitchPID_P
                                          //  Referenced by: '<S49>/Proportional Gain'

  real_T YawPID_P;                     // Mask Parameter: YawPID_P
                                          //  Referenced by: '<S145>/Proportional Gain'

  px4_Bus_vehicle_odometry Out1_Y0;    // Computed Parameter: Out1_Y0
                                          //  Referenced by: '<S163>/Out1'

  px4_Bus_vehicle_odometry Constant_Value;// Computed Parameter: Constant_Value
                                             //  Referenced by: '<S162>/Constant'

  px4_Bus_input_rc Out1_Y0_e;          // Computed Parameter: Out1_Y0_e
                                          //  Referenced by: '<S161>/Out1'

  px4_Bus_input_rc Constant_Value_h;   // Computed Parameter: Constant_Value_h
                                          //  Referenced by: '<S160>/Constant'

  px4_Bus_esc_report Out1_Y0_j;        // Computed Parameter: Out1_Y0_j
                                          //  Referenced by: '<S158>/Out1'

  px4_Bus_esc_report Out1_Y0_jd;       // Computed Parameter: Out1_Y0_jd
                                          //  Referenced by: '<S159>/Out1'

  px4_Bus_esc_report Constant_Value_l; // Computed Parameter: Constant_Value_l
                                          //  Referenced by: '<S4>/Constant'

  px4_Bus_esc_report Constant_Value_d; // Computed Parameter: Constant_Value_d
                                          //  Referenced by: '<S5>/Constant'

  px4_Bus_actuator_armed Out1_Y0_jc;   // Computed Parameter: Out1_Y0_jc
                                          //  Referenced by: '<S157>/Out1'

  px4_Bus_actuator_armed Constant_Value_m;// Computed Parameter: Constant_Value_m
                                             //  Referenced by: '<S3>/Constant'

  real_T Constant1_Value;              // Expression: 1500
                                          //  Referenced by: '<S7>/Constant1'

  real_T Constant_Value_g;             // Expression: 1000
                                          //  Referenced by: '<S7>/Constant'

  real_T Gain1_Gain;                   // Expression: -1
                                          //  Referenced by: '<S2>/Gain1'

  real_T Constant2_Value;              // Expression: 1000
                                          //  Referenced by: '<Root>/Constant2'

  real_T Gain1_Gain_g;                 // Expression: 1
                                          //  Referenced by: '<Root>/Gain1'

  real_T Gain_Gain;                    // Expression: 1/4
                                          //  Referenced by: '<S9>/Gain'

  real_T Constant_Value_g0;            // Expression: 1500
                                          //  Referenced by: '<Root>/Constant'

  real_T Gain5_Gain;                   // Expression: 1/500
                                          //  Referenced by: '<Root>/Gain5'

  real_T uL_Gain;                      // Expression: 1/0.3
                                          //  Referenced by: '<S9>/1//L'

  real_T _Gain;                        // Expression: 0.5
                                          //  Referenced by: '<S9>/•ª”z'

  real_T uL_Gain_f;                    // Expression: 1/0.3
                                          //  Referenced by: '<S9>/1//L''

  real_T u_Gain;                       // Expression: 0.5
                                          //  Referenced by: '<S9>/•ª”z1'

  real_T ub_Gain;                      // Expression: 1/1e-6
                                          //  Referenced by: '<S9>/1//b'

  real_T uk_Gain;                      // Expression: 1/1.140e-7
                                          //  Referenced by: '<S9>/1//k'

  real_T Gain2_Gain;                   // Expression: 1/4
                                          //  Referenced by: '<S9>/Gain2'

  real_T Gain3_Gain;                   // Expression: -1
                                          //  Referenced by: '<S9>/Gain3'

  real_T Gain4_Gain;                   // Expression: -1
                                          //  Referenced by: '<S9>/Gain4'

  real_T Saturation_UpperSat;          // Expression: inf
                                          //  Referenced by: '<S9>/Saturation'

  real_T Saturation_LowerSat;          // Expression: 0
                                          //  Referenced by: '<S9>/Saturation'

  real_T Gain_Gain_d;                  // Expression: 1/30
                                          //  Referenced by: '<Root>/Gain'

  real_T Constant1_Value_g;            // Expression: 1000
                                          //  Referenced by: '<Root>/Constant1'

  real_T PWMSaturation_UpperSat;       // Expression: 2000
                                          //  Referenced by: '<Root>/PWM Saturation'

  real_T PWMSaturation_LowerSat;       // Expression: 1000
                                          //  Referenced by: '<Root>/PWM Saturation'

  real_T switch_Threshold;             // Expression: 1500
                                          //  Referenced by: '<Root>/switch'

  real32_T Gain2_Gain_l;               // Computed Parameter: Gain2_Gain_l
                                          //  Referenced by: '<S2>/Gain2'

  uint16_T Saturation_UpperSat_o;   // Computed Parameter: Saturation_UpperSat_o
                                       //  Referenced by: '<S7>/Saturation'

  uint16_T Saturation_LowerSat_p;   // Computed Parameter: Saturation_LowerSat_p
                                       //  Referenced by: '<S7>/Saturation'

  uint16_T SignalFS_Threshold;         // Computed Parameter: SignalFS_Threshold
                                          //  Referenced by: '<S7>/Signal FS'

  boolean_T Constant3_Value;           // Computed Parameter: Constant3_Value
                                          //  Referenced by: '<Root>/Constant3'

  boolean_T Constant4_Value;           // Computed Parameter: Constant4_Value
                                          //  Referenced by: '<Root>/Constant4'

  boolean_T Constant2_Value_l;         // Computed Parameter: Constant2_Value_l
                                          //  Referenced by: '<S7>/Constant2'

  boolean_T Constant3_Value_m;         // Computed Parameter: Constant3_Value_m
                                          //  Referenced by: '<S7>/Constant3'

  boolean_T Constant5_Value;           // Computed Parameter: Constant5_Value
                                          //  Referenced by: '<Root>/Constant5'

  uint8_T Gain1_Gain_n;                // Computed Parameter: Gain1_Gain_n
                                          //  Referenced by: '<S6>/Gain1'

  uint8_T Gain_Gain_k;                 // Computed Parameter: Gain_Gain_k
                                          //  Referenced by: '<S6>/Gain'

  uint8_T PROPOFS_Threshold;           // Computed Parameter: PROPOFS_Threshold
                                          //  Referenced by: '<S7>/PROPO FS'

};

// Real-time Model Data Structure
struct tag_RTM_PX4_PID_T {
  const char_T * volatile errorStatus;

  //
  //  Timing:
  //  The following substructure contains information regarding
  //  the timing information for the model.

  struct {
    struct {
      uint8_T TID[2];
    } TaskCounters;
  } Timing;
};

// Block parameters (default storage)
#ifdef __cplusplus

extern "C"
{

#endif

  extern P_PX4_PID_T PX4_PID_P;

#ifdef __cplusplus

}

#endif

// Block signals (default storage)
#ifdef __cplusplus

extern "C"
{

#endif

  extern struct B_PX4_PID_T PX4_PID_B;

#ifdef __cplusplus

}

#endif

// Block states (default storage)
extern struct DW_PX4_PID_T PX4_PID_DW;

// External function called from main
#ifdef __cplusplus

extern "C"
{

#endif

  extern void PX4_PID_SetEventsForThisBaseStep(boolean_T *eventFlags);

#ifdef __cplusplus

}

#endif

#ifdef __cplusplus

extern "C"
{

#endif

  // Model entry point functions
  extern void PX4_PID_initialize(void);
  extern void PX4_PID_step0(void);
  extern void PX4_PID_step1(void);
  extern void PX4_PID_step(int_T tid);
  extern void PX4_PID_terminate(void);

#ifdef __cplusplus

}

#endif

// Real-time Model object
#ifdef __cplusplus

extern "C"
{

#endif

  extern RT_MODEL_PX4_PID_T *const PX4_PID_M;

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
//  Block '<Root>/Display5' : Unused code path elimination
//  Block '<Root>/Display6' : Unused code path elimination
//  Block '<S3>/NOT' : Unused code path elimination
//  Block '<S4>/NOT' : Unused code path elimination
//  Block '<S5>/NOT' : Unused code path elimination
//  Block '<S162>/NOT' : Unused code path elimination


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
//  '<Root>' : 'PX4_PID'
//  '<S1>'   : 'PX4_PID/Attitude PID controller'
//  '<S2>'   : 'PX4_PID/PX4 to lab axis'
//  '<S3>'   : 'PX4_PID/PX4 uORB Read'
//  '<S4>'   : 'PX4_PID/PX4 uORB Read1'
//  '<S5>'   : 'PX4_PID/PX4 uORB Read2'
//  '<S6>'   : 'PX4_PID/Radio Control Transmitter'
//  '<S7>'   : 'PX4_PID/Subsystem'
//  '<S8>'   : 'PX4_PID/Vehicle Attitude1'
//  '<S9>'   : 'PX4_PID/torque2roter'
//  '<S10>'  : 'PX4_PID/Attitude PID controller/Pitch PID'
//  '<S11>'  : 'PX4_PID/Attitude PID controller/Roll PID'
//  '<S12>'  : 'PX4_PID/Attitude PID controller/Yaw PID'
//  '<S13>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Anti-windup'
//  '<S14>'  : 'PX4_PID/Attitude PID controller/Pitch PID/D Gain'
//  '<S15>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Filter'
//  '<S16>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Filter ICs'
//  '<S17>'  : 'PX4_PID/Attitude PID controller/Pitch PID/I Gain'
//  '<S18>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Ideal P Gain'
//  '<S19>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Ideal P Gain Fdbk'
//  '<S20>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Integrator'
//  '<S21>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Integrator ICs'
//  '<S22>'  : 'PX4_PID/Attitude PID controller/Pitch PID/N Copy'
//  '<S23>'  : 'PX4_PID/Attitude PID controller/Pitch PID/N Gain'
//  '<S24>'  : 'PX4_PID/Attitude PID controller/Pitch PID/P Copy'
//  '<S25>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Parallel P Gain'
//  '<S26>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Reset Signal'
//  '<S27>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Saturation'
//  '<S28>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Saturation Fdbk'
//  '<S29>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Sum'
//  '<S30>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Sum Fdbk'
//  '<S31>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Tracking Mode'
//  '<S32>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Tracking Mode Sum'
//  '<S33>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Tsamp - Integral'
//  '<S34>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Tsamp - Ngain'
//  '<S35>'  : 'PX4_PID/Attitude PID controller/Pitch PID/postSat Signal'
//  '<S36>'  : 'PX4_PID/Attitude PID controller/Pitch PID/preSat Signal'
//  '<S37>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Anti-windup/Disabled'
//  '<S38>'  : 'PX4_PID/Attitude PID controller/Pitch PID/D Gain/Disabled'
//  '<S39>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Filter/Disabled'
//  '<S40>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Filter ICs/Disabled'
//  '<S41>'  : 'PX4_PID/Attitude PID controller/Pitch PID/I Gain/Disabled'
//  '<S42>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Ideal P Gain/Passthrough'
//  '<S43>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Ideal P Gain Fdbk/Disabled'
//  '<S44>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Integrator/Disabled'
//  '<S45>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Integrator ICs/Disabled'
//  '<S46>'  : 'PX4_PID/Attitude PID controller/Pitch PID/N Copy/Disabled wSignal Specification'
//  '<S47>'  : 'PX4_PID/Attitude PID controller/Pitch PID/N Gain/Disabled'
//  '<S48>'  : 'PX4_PID/Attitude PID controller/Pitch PID/P Copy/Disabled'
//  '<S49>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Parallel P Gain/Internal Parameters'
//  '<S50>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Reset Signal/Disabled'
//  '<S51>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Saturation/Passthrough'
//  '<S52>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Saturation Fdbk/Disabled'
//  '<S53>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Sum/Passthrough_P'
//  '<S54>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Sum Fdbk/Disabled'
//  '<S55>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Tracking Mode/Disabled'
//  '<S56>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Tracking Mode Sum/Passthrough'
//  '<S57>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Tsamp - Integral/TsSignalSpecification'
//  '<S58>'  : 'PX4_PID/Attitude PID controller/Pitch PID/Tsamp - Ngain/Passthrough'
//  '<S59>'  : 'PX4_PID/Attitude PID controller/Pitch PID/postSat Signal/Forward_Path'
//  '<S60>'  : 'PX4_PID/Attitude PID controller/Pitch PID/preSat Signal/Forward_Path'
//  '<S61>'  : 'PX4_PID/Attitude PID controller/Roll PID/Anti-windup'
//  '<S62>'  : 'PX4_PID/Attitude PID controller/Roll PID/D Gain'
//  '<S63>'  : 'PX4_PID/Attitude PID controller/Roll PID/Filter'
//  '<S64>'  : 'PX4_PID/Attitude PID controller/Roll PID/Filter ICs'
//  '<S65>'  : 'PX4_PID/Attitude PID controller/Roll PID/I Gain'
//  '<S66>'  : 'PX4_PID/Attitude PID controller/Roll PID/Ideal P Gain'
//  '<S67>'  : 'PX4_PID/Attitude PID controller/Roll PID/Ideal P Gain Fdbk'
//  '<S68>'  : 'PX4_PID/Attitude PID controller/Roll PID/Integrator'
//  '<S69>'  : 'PX4_PID/Attitude PID controller/Roll PID/Integrator ICs'
//  '<S70>'  : 'PX4_PID/Attitude PID controller/Roll PID/N Copy'
//  '<S71>'  : 'PX4_PID/Attitude PID controller/Roll PID/N Gain'
//  '<S72>'  : 'PX4_PID/Attitude PID controller/Roll PID/P Copy'
//  '<S73>'  : 'PX4_PID/Attitude PID controller/Roll PID/Parallel P Gain'
//  '<S74>'  : 'PX4_PID/Attitude PID controller/Roll PID/Reset Signal'
//  '<S75>'  : 'PX4_PID/Attitude PID controller/Roll PID/Saturation'
//  '<S76>'  : 'PX4_PID/Attitude PID controller/Roll PID/Saturation Fdbk'
//  '<S77>'  : 'PX4_PID/Attitude PID controller/Roll PID/Sum'
//  '<S78>'  : 'PX4_PID/Attitude PID controller/Roll PID/Sum Fdbk'
//  '<S79>'  : 'PX4_PID/Attitude PID controller/Roll PID/Tracking Mode'
//  '<S80>'  : 'PX4_PID/Attitude PID controller/Roll PID/Tracking Mode Sum'
//  '<S81>'  : 'PX4_PID/Attitude PID controller/Roll PID/Tsamp - Integral'
//  '<S82>'  : 'PX4_PID/Attitude PID controller/Roll PID/Tsamp - Ngain'
//  '<S83>'  : 'PX4_PID/Attitude PID controller/Roll PID/postSat Signal'
//  '<S84>'  : 'PX4_PID/Attitude PID controller/Roll PID/preSat Signal'
//  '<S85>'  : 'PX4_PID/Attitude PID controller/Roll PID/Anti-windup/Disabled'
//  '<S86>'  : 'PX4_PID/Attitude PID controller/Roll PID/D Gain/Disabled'
//  '<S87>'  : 'PX4_PID/Attitude PID controller/Roll PID/Filter/Disabled'
//  '<S88>'  : 'PX4_PID/Attitude PID controller/Roll PID/Filter ICs/Disabled'
//  '<S89>'  : 'PX4_PID/Attitude PID controller/Roll PID/I Gain/Disabled'
//  '<S90>'  : 'PX4_PID/Attitude PID controller/Roll PID/Ideal P Gain/Passthrough'
//  '<S91>'  : 'PX4_PID/Attitude PID controller/Roll PID/Ideal P Gain Fdbk/Disabled'
//  '<S92>'  : 'PX4_PID/Attitude PID controller/Roll PID/Integrator/Disabled'
//  '<S93>'  : 'PX4_PID/Attitude PID controller/Roll PID/Integrator ICs/Disabled'
//  '<S94>'  : 'PX4_PID/Attitude PID controller/Roll PID/N Copy/Disabled wSignal Specification'
//  '<S95>'  : 'PX4_PID/Attitude PID controller/Roll PID/N Gain/Disabled'
//  '<S96>'  : 'PX4_PID/Attitude PID controller/Roll PID/P Copy/Disabled'
//  '<S97>'  : 'PX4_PID/Attitude PID controller/Roll PID/Parallel P Gain/Internal Parameters'
//  '<S98>'  : 'PX4_PID/Attitude PID controller/Roll PID/Reset Signal/Disabled'
//  '<S99>'  : 'PX4_PID/Attitude PID controller/Roll PID/Saturation/Passthrough'
//  '<S100>' : 'PX4_PID/Attitude PID controller/Roll PID/Saturation Fdbk/Disabled'
//  '<S101>' : 'PX4_PID/Attitude PID controller/Roll PID/Sum/Passthrough_P'
//  '<S102>' : 'PX4_PID/Attitude PID controller/Roll PID/Sum Fdbk/Disabled'
//  '<S103>' : 'PX4_PID/Attitude PID controller/Roll PID/Tracking Mode/Disabled'
//  '<S104>' : 'PX4_PID/Attitude PID controller/Roll PID/Tracking Mode Sum/Passthrough'
//  '<S105>' : 'PX4_PID/Attitude PID controller/Roll PID/Tsamp - Integral/TsSignalSpecification'
//  '<S106>' : 'PX4_PID/Attitude PID controller/Roll PID/Tsamp - Ngain/Passthrough'
//  '<S107>' : 'PX4_PID/Attitude PID controller/Roll PID/postSat Signal/Forward_Path'
//  '<S108>' : 'PX4_PID/Attitude PID controller/Roll PID/preSat Signal/Forward_Path'
//  '<S109>' : 'PX4_PID/Attitude PID controller/Yaw PID/Anti-windup'
//  '<S110>' : 'PX4_PID/Attitude PID controller/Yaw PID/D Gain'
//  '<S111>' : 'PX4_PID/Attitude PID controller/Yaw PID/Filter'
//  '<S112>' : 'PX4_PID/Attitude PID controller/Yaw PID/Filter ICs'
//  '<S113>' : 'PX4_PID/Attitude PID controller/Yaw PID/I Gain'
//  '<S114>' : 'PX4_PID/Attitude PID controller/Yaw PID/Ideal P Gain'
//  '<S115>' : 'PX4_PID/Attitude PID controller/Yaw PID/Ideal P Gain Fdbk'
//  '<S116>' : 'PX4_PID/Attitude PID controller/Yaw PID/Integrator'
//  '<S117>' : 'PX4_PID/Attitude PID controller/Yaw PID/Integrator ICs'
//  '<S118>' : 'PX4_PID/Attitude PID controller/Yaw PID/N Copy'
//  '<S119>' : 'PX4_PID/Attitude PID controller/Yaw PID/N Gain'
//  '<S120>' : 'PX4_PID/Attitude PID controller/Yaw PID/P Copy'
//  '<S121>' : 'PX4_PID/Attitude PID controller/Yaw PID/Parallel P Gain'
//  '<S122>' : 'PX4_PID/Attitude PID controller/Yaw PID/Reset Signal'
//  '<S123>' : 'PX4_PID/Attitude PID controller/Yaw PID/Saturation'
//  '<S124>' : 'PX4_PID/Attitude PID controller/Yaw PID/Saturation Fdbk'
//  '<S125>' : 'PX4_PID/Attitude PID controller/Yaw PID/Sum'
//  '<S126>' : 'PX4_PID/Attitude PID controller/Yaw PID/Sum Fdbk'
//  '<S127>' : 'PX4_PID/Attitude PID controller/Yaw PID/Tracking Mode'
//  '<S128>' : 'PX4_PID/Attitude PID controller/Yaw PID/Tracking Mode Sum'
//  '<S129>' : 'PX4_PID/Attitude PID controller/Yaw PID/Tsamp - Integral'
//  '<S130>' : 'PX4_PID/Attitude PID controller/Yaw PID/Tsamp - Ngain'
//  '<S131>' : 'PX4_PID/Attitude PID controller/Yaw PID/postSat Signal'
//  '<S132>' : 'PX4_PID/Attitude PID controller/Yaw PID/preSat Signal'
//  '<S133>' : 'PX4_PID/Attitude PID controller/Yaw PID/Anti-windup/Disabled'
//  '<S134>' : 'PX4_PID/Attitude PID controller/Yaw PID/D Gain/Disabled'
//  '<S135>' : 'PX4_PID/Attitude PID controller/Yaw PID/Filter/Disabled'
//  '<S136>' : 'PX4_PID/Attitude PID controller/Yaw PID/Filter ICs/Disabled'
//  '<S137>' : 'PX4_PID/Attitude PID controller/Yaw PID/I Gain/Disabled'
//  '<S138>' : 'PX4_PID/Attitude PID controller/Yaw PID/Ideal P Gain/Passthrough'
//  '<S139>' : 'PX4_PID/Attitude PID controller/Yaw PID/Ideal P Gain Fdbk/Disabled'
//  '<S140>' : 'PX4_PID/Attitude PID controller/Yaw PID/Integrator/Disabled'
//  '<S141>' : 'PX4_PID/Attitude PID controller/Yaw PID/Integrator ICs/Disabled'
//  '<S142>' : 'PX4_PID/Attitude PID controller/Yaw PID/N Copy/Disabled wSignal Specification'
//  '<S143>' : 'PX4_PID/Attitude PID controller/Yaw PID/N Gain/Disabled'
//  '<S144>' : 'PX4_PID/Attitude PID controller/Yaw PID/P Copy/Disabled'
//  '<S145>' : 'PX4_PID/Attitude PID controller/Yaw PID/Parallel P Gain/Internal Parameters'
//  '<S146>' : 'PX4_PID/Attitude PID controller/Yaw PID/Reset Signal/Disabled'
//  '<S147>' : 'PX4_PID/Attitude PID controller/Yaw PID/Saturation/Passthrough'
//  '<S148>' : 'PX4_PID/Attitude PID controller/Yaw PID/Saturation Fdbk/Disabled'
//  '<S149>' : 'PX4_PID/Attitude PID controller/Yaw PID/Sum/Passthrough_P'
//  '<S150>' : 'PX4_PID/Attitude PID controller/Yaw PID/Sum Fdbk/Disabled'
//  '<S151>' : 'PX4_PID/Attitude PID controller/Yaw PID/Tracking Mode/Disabled'
//  '<S152>' : 'PX4_PID/Attitude PID controller/Yaw PID/Tracking Mode Sum/Passthrough'
//  '<S153>' : 'PX4_PID/Attitude PID controller/Yaw PID/Tsamp - Integral/TsSignalSpecification'
//  '<S154>' : 'PX4_PID/Attitude PID controller/Yaw PID/Tsamp - Ngain/Passthrough'
//  '<S155>' : 'PX4_PID/Attitude PID controller/Yaw PID/postSat Signal/Forward_Path'
//  '<S156>' : 'PX4_PID/Attitude PID controller/Yaw PID/preSat Signal/Forward_Path'
//  '<S157>' : 'PX4_PID/PX4 uORB Read/Enabled Subsystem'
//  '<S158>' : 'PX4_PID/PX4 uORB Read1/Enabled Subsystem'
//  '<S159>' : 'PX4_PID/PX4 uORB Read2/Enabled Subsystem'
//  '<S160>' : 'PX4_PID/Radio Control Transmitter/PX4 uORB Read'
//  '<S161>' : 'PX4_PID/Radio Control Transmitter/PX4 uORB Read/Enabled Subsystem'
//  '<S162>' : 'PX4_PID/Vehicle Attitude1/PX4 uORB Read'
//  '<S163>' : 'PX4_PID/Vehicle Attitude1/PX4 uORB Read/Enabled Subsystem'

#endif                                 // RTW_HEADER_PX4_PID_h_

//
// File trailer for generated code.
//
// [EOF]
//
