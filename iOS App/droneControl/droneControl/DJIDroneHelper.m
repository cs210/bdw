//
//  DJIDroneHelper.m
//  droneControl
//
//  Created by Michael Weingert on 2015-05-05.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "DJIDroneHelper.h"
#import <DJISDK/DJISDK.h>
//#import <DJISDK/DJIGroundStation.h>

@implementation DJIDroneHelper
{
  DJIMCSystemState *_lastKnownState;
  
  DJIDrone *_drone;
  
  NSObject<DJIGroundStation>* _groundStation;
  
  DJIGroundStationFlyingInfo * _lastFlyingInfo;
}

+ (id)sharedHelper {
  static DJIDroneHelper *sharedDroneHelper = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedDroneHelper = [[self alloc] init];
  });
  return sharedDroneHelper;
}

- (id)init {
  if (self = [super init]) {
      _drone = [[DJIDrone alloc] initWithType:DJIDrone_Phantom];
      [_drone connectToDrone];
      _drone.mainController.mcDelegate = self;
    
    _groundStation = (id<DJIGroundStation>)_drone.mainController;
    _groundStation.groundStationDelegate = self;
    
    [_drone.camera getCameraGps:^(CLLocationCoordinate2D coordinate, DJIError* error)
    {
      NSLog(@"Drone get Camera GPS");
      NSLog(@"Coordinate received: Lat %f Long %f", coordinate.latitude, coordinate.longitude);
    }];
  }
  return self;
}

-(void) cleanUpResources
{
  [_drone disconnectToDrone];
  [_drone destroy];
}

-(void) mainController:(DJIMainController*)mc didUpdateSystemState:(DJIMCSystemState*)state
{
  // Here we now have access to all GPS information
  _lastKnownState = state;
}

-(CLLocationCoordinate2D) getDroneGPS
{
  /*[_drone.camera getCameraGps:^(CLLocationCoordinate2D coordinate, DJIError* error)
   {
     NSLog(@"Drone get Camera GPS");
     NSLog(@"Coordinate received: Lat %f Long %f", coordinate.latitude, coordinate.longitude);
   }];*/
  return _lastFlyingInfo.droneLocation;
//  return _lastKnownState.droneLocation;
}

-(float) getDroneHeight
{
  return _lastFlyingInfo.altitude;
  //return _lastKnownState.altitude;
}

/**
 *  Ground station flying status.
 */
-(void) groundStation:(id<DJIGroundStation>)gs didUpdateFlyingInformation:(DJIGroundStationFlyingInfo*)flyingInfo
{
  //Store the shit here
  _lastFlyingInfo = flyingInfo;
}

@end