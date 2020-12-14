/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: main.c
 *
 * MATLAB Coder version            : 5.0
 * C/C++ source code generated on  : 04-Nov-2020 16:27:23
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

/* Include Files */
#include "main.h"
#include "Line_Setting.h"
#include "Line_Setting_terminate.h"

/* Function Declarations */
static void argInit_d3xd4_real_T(double result_data[], int result_size[2]);
static double argInit_real_T(void);
static void main_Line_Setting(void);

/* Function Definitions */

/*
 * Arguments    : double result_data[]
 *                int result_size[2]
 * Return Type  : void
 */
static void argInit_d3xd4_real_T(double result_data[], int result_size[2])
{
  int idx0;
  int idx1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result_size[0] = 2;
  result_size[1] = 2;

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 2; idx0++) {
    for (idx1 = 0; idx1 < 2; idx1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result_data[idx0 + 2 * idx1] = argInit_real_T();
    }
  }
}

/*
 * Arguments    : void
 * Return Type  : double
 */
static double argInit_real_T(void)
{
  return 0.0;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void main_Line_Setting(void)
{
  double Sectionnumber_tmp;
  double Sectionpoint_data[12];
  int Sectionpoint_size[2];
  double p_return[38];

  /* Initialize function 'Line_Setting' input arguments. */
  Sectionnumber_tmp = argInit_real_T();

  /* Initialize function input argument 'Sectionpoint'. */
  argInit_d3xd4_real_T(Sectionpoint_data, Sectionpoint_size);

  /* Call the entry-point 'Line_Setting'. */
  Line_Setting(Sectionnumber_tmp, Sectionpoint_data, Sectionpoint_size,
               Sectionnumber_tmp, Sectionnumber_tmp, p_return);
}

/*
 * Arguments    : int argc
 *                const char * const argv[]
 * Return Type  : int
 */
int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* The initialize function is being called automatically from your entry-point function. So, a call to initialize is not included here. */
  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_Line_Setting();

  /* Terminate the application.
     You do not need to do this more than one time. */
  Line_Setting_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
