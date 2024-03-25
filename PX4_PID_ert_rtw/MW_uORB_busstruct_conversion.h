#ifndef _MW_UORB_BUSSTRUCT_CONVERSION_H_
#define _MW_UORB_BUSSTRUCT_CONVERSION_H_

#include <uORB/topics/actuator_armed.h>
#include <uORB/topics/esc_report.h>
#include <uORB/topics/esc_status.h>
#include <uORB/topics/input_rc.h>
#include <uORB/topics/vehicle_odometry.h>

typedef struct actuator_armed_s  px4_Bus_actuator_armed ;
typedef struct esc_report_s  px4_Bus_esc_report ;
typedef struct esc_status_s  px4_Bus_esc_status ;
typedef struct input_rc_s  px4_Bus_input_rc ;
typedef struct vehicle_odometry_s  px4_Bus_vehicle_odometry ;

#endif
