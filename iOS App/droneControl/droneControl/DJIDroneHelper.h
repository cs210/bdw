//
//  DJIDroneHelper.h
//  droneControl
//
//  Created by Michael Weingert on 2015-05-05.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DJISDK/DJISDK.h>

@interface DJIDroneHelper : NSObject<DJIMainControllerDelegate, GroundStationDelegate>

/*!
 @class DJIDroneHelper
 @abstract A wrapper class around drone functionality
 @discussion This class acts as a wrapper around the drone functionality. This class receives drone events and, behind the scenes, processes it so that the yaw, altitude, and other information is available to the program through a singleton. This class was designed to provide a single point of access to drone code, and to obscure many of the unnecessary elements of the drone and to provide a simple, clear, interface to interact with.
 */


/*!
 * @brief A reference to the sole instance of the drone
 */
@property (strong, readwrite, nonatomic) DJIDrone * drone;

/*!
 * @brief The last known system state
 */
@property DJIMCSystemState *lastKnownState;

/*!
 * @brief The ground station responsible for controlling drone flying
 */
@property NSObject<DJIGroundStation>* groundStation;

/*!
 * @brief The location of the base station
 */
@property CLLocationCoordinate2D homeLocation;

/*!
 * @brief The last known flying information (altitude, yaw, gps, etc)
 */
@property DJIGroundStationFlyingInfo * lastFlyingInfo;

/*!
 * @discussion Return a singleton reference to the drone helper class
 * @return A reference to the helper class
 */
+ (instancetype)sharedHelper;

/*!
 * @discussion Method called when the main dji controller has updated the system state
 * @param mc The dji main controller that controls the drone state
 * @param state The updated drone system state
 */
-(void) mainController:(DJIMainController*)mc didUpdateSystemState:(DJIMCSystemState*)state;

/*!
 * @discussion Getter for the last recorded drone GPS location
 * @return The last recorded drone GPS location
 */
-(CLLocationCoordinate2D) getDroneGPS;

/*!
 * @discussion Getter for the last recorded drone height
 * @return The last recorded drone height
 */
-(float) getDroneHeight;

/*!
 * @discussion A public method to be called when the drone is first launched
 */
-(void) onOpenButtonClicked;

/*!
 * @discussion Getter for the last recorded drone yaw
 * @return The last recorded drone yaw
 */
-(float) getDroneYaw;

/*!
 * @discussion Create a basic drone task (as a drone task is required in order for system state to get updated)
 */
-(void) droneTask:(id)sender;

@end
