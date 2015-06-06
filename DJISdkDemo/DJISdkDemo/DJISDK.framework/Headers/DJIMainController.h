//
//  DJIMainController.h
//  DJISDK
//
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <DJISDK/DJIObject.h>
#import <DJISDK/DJIGroundStation.h>

@class DJIMCSystemState;

typedef NS_ENUM(NSInteger, MCError)
{
    MC_NO_ERROR,
    MC_CONFIG_ERROR,
    MC_SERIALNUM_ERROR,
    MC_IMU_ERROR,
    MC_X1_ERROR,
    MC_X2_ERROR,
    MC_PMU_ERROR,
    MC_TRANSMITTER_ERROR,
    MC_SENSOR_ERROR,
    MC_COMPASS_ERROR,
    MC_IMU_CALIBRATION_ERROR,
    MC_COMPASS_CALIBRATION_ERROR,
    MC_TRANSMITTER_CALIBRATION_ERROR,
    MC_INVALID_BATTERY_ERROR,
    MC_INVALID_BATTERY_COMMUNICATION_ERROR
};

typedef struct
{
    double pitch;
    double roll;
    double yaw;
} DJIAttitude;


typedef struct
{
    float zoneRadius;
    CLLocationCoordinate2D zoneCenterCoordinate;
} DJINoFlyZone;

typedef struct
{
    BOOL isReachMaxHeight;
    BOOL isReachMaxDistance;
    Float32 maxLimitHeight;
    Float32 maxLimitDistance;
} DJILimitFlyStatus;

@class DJIMainController;

@protocol DJIMainControllerDelegate <NSObject>

@optional

/**
 *  Notify on main controller error
 *
 */
-(void) mainController:(DJIMainController*)mc didMainControlError:(MCError)error;

/**
 *  Update main controller system state
 *
 */
-(void) mainController:(DJIMainController*)mc didUpdateSystemState:(DJIMCSystemState*)state;

@end


@interface DJIMainController : DJIObject <DJIGroundStation>

/**
 *  Manin controller delegate
 */
@property(nonatomic, weak) id<DJIMainControllerDelegate> mcDelegate;

/**
 *  Main controller's firmware version.
 *
 */
-(NSString*) getMainControllerVersion;

/**
 *  Start update main controller's system state
 */
-(void) startUpdateMCSystemState;

/**
 *  Stop update main controller's system state
 */
-(void) stopUpdateMCSystemState;

/**
 *  Set the fly limitation parameter.
 *
 *  @param limitParam The max height and distance parameters
 *  @param block      Remote execute result
 */
-(void) setLimitFlyWithHeight:(float)height Distance:(float)distance withResult:(DJIExecuteResultBlock)block;

/**
 *  Get the limit fly parameter. if execute success, result will be set to 'limitFlyParameter'
 *
 *  @param block Remote execute result
 */
-(void) getLimitFlyWithResultBlock:(void(^)(DJILimitFlyStatus limitStatus, DJIError*))block;

/**
 *  Set a no fly zone. Not support now.
 *
 *  @param noFlyZone No fly zone parameter
 *  @param block     Remote execute result
 */
-(void) setNoFly:(DJINoFlyZone)noFlyZone withResult:(DJIExecuteResultBlock)block;

/**
 *  Set home point to drone. Home point is use for back home when the drone lost signal or other case.
 *  The drone use current located location as default home point while it first start and receive enough satellite( >= 6).
 *  User should be carefully to change the home point.
 *
 *  @param homePoint Home point in degree.
 *  @param block     Remote execute result
 */
-(void) setHomePoint:(CLLocationCoordinate2D)homePoint withResult:(DJIExecuteResultBlock)block;

/**
 *  Get home point of drone.
 *
 *  @param block   Remote execute result. The homePoint is in degree.
 */
-(void) getHomePoint:(void(^)(CLLocationCoordinate2D homePoint, DJIError* error))block;

/**
 *  Set go home default altitude. The default altitude is used by the drone every time while going home.
 *
 *  @param altitude  Drone altitude in meter for going home. [20m - 500m] and could not over the limited height.
 *  @param block     Remote execute result
 */
-(void) setGoHomeDefaultAltitude:(float)altitude withResult:(DJIExecuteResultBlock)block;

/**
 *  Get the default altitude of go home.
 *
 *  @param block  Remote execute result
 */
-(void) getGoHomeDefaultAltitude:(void(^)(float altitude, DJIError* error))block;

/**
 *  Set go home temporary altitude. The temporary altitude is used by the drone this time while going home.
 *
 *  @param tmpAltitude  Drone temporary altitude in meter for going home. [20m - 500m] and could not over the limited height.
 *  @param block     Remote execute result
 */
-(void) setGoHomeTemporaryAltitude:(float)tmpAltitude withResult:(DJIExecuteResultBlock)block;

/**
 *  Get go home default altitude.
 *
 *  @param block  Remote execute result
 */
-(void) getGoHomeTemporaryAltitude:(void(^)(float altitude, DJIError* error))block;


@end
