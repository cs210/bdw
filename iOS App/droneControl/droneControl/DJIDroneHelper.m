//
//  DJIDroneHelper.m
//  droneControl
//
//  Created by Michael Weingert on 2015-05-05.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "DJIDroneHelper.h"

@implementation DJIDroneHelper
{
  DJIMCSystemState *_lastKnownState;
  
  DJIDrone *_drone;
}

+ (id)sharedManager {
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
  return _lastKnownState.droneLocation;
}

-(float) getDroneHeight
{
  return _lastKnownState.altitude;
}

@end