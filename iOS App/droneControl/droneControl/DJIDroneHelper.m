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
#define RADIAN(x) ((x)*M_PI/180.0)

@implementation DJIDroneHelper
{
  DJIMCSystemState *_lastKnownState;
  
  DJIDrone *_drone;
  
  NSObject<DJIGroundStation>* _groundStation;
    CLLocationCoordinate2D _homeLocation;
  
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
    float yaw = [self getDroneYaw];
   // NSLog(@"didUpdateSystemState , %f",yaw);
}

-(void) droneTask:(id)sender
{
    const float height = 1;
    DJIGroundStationTask* newTask = [DJIGroundStationTask newTask];
    
    if (CLLocationCoordinate2DIsValid(_homeLocation)) {
        NSLog(@"HOME LOCATION EXISTS");
        
        CLLocationCoordinate2D point1 = CLLocationCoordinate2DMake(_homeLocation.latitude, _homeLocation.longitude);
        
        DJIGroundStationWaypoint* wp1 = [[DJIGroundStationWaypoint alloc] initWithCoordinate:point1];
        wp1.altitude = height;
        wp1.horizontalVelocity = 0;
        wp1.stayTime = 7.0;
        
        [newTask addWaypoint:wp1];
    }
    
    [_groundStation uploadGroundStationTask:newTask];
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
    // FOR DEBUGGING
  //return 100;
  return _lastFlyingInfo.altitude;
  //return _lastKnownState.altitude;
}

// at startup: -pi
-(float) getDroneYaw
{
  // Need to combo that shit with the camera yaw
    float pi = 3.1415926535;
    float outt = RADIAN(_lastFlyingInfo.attitude.yaw) + pi;
    if (outt < -pi){
        outt += (2 * pi);
    }
    return outt;
}



//delegate


/**
 *  Ground station flying status.
 */
-(void) groundStation:(id<DJIGroundStation>)gs didUpdateFlyingInformation:(DJIGroundStationFlyingInfo*)flyingInfo
{
  //Store the shit here
  _lastFlyingInfo = flyingInfo;
    NSLog(@"Yaw: %f, Altitude: %f, Latitude: %f, Longitude: %f", flyingInfo.attitude.yaw, flyingInfo.altitude, flyingInfo.droneLocation.latitude, flyingInfo.droneLocation.longitude);

    _homeLocation = flyingInfo.homeLocation;
    
}


-(void) groundStation:(id<DJIGroundStation>)gs didExecuteWithResult:(GroundStationExecuteResult*)result
{
    switch (result.currentAction) {
        case GSActionOpen:
        {
            [self onGroundStationOpenWithResult:result];
            break;
        }
        case GSActionClose:
        {
            [self onGroundStationCloseWithResult:result];
            break;
        }
        case GSActionUploadTask:
        {
            [self onGroundStationUploadTaskWithResult:result];
            break;
        }
        default:
            break;
    }
}



-(void) onOpenButtonClicked
{
    [_groundStation openGroundStation];
    [self droneTask:self];
}

-(IBAction) onCloseButtonClicked:(id)sender
{
    [_groundStation closeGroundStation];
}


-(void) onGroundStationOpenWithResult:(GroundStationExecuteResult*)result
{
    if (result.executeStatus == GSExecStatusBegan) {
        NSLog(@"Ground Station Open Began");
    }
    else if (result.executeStatus == GSExecStatusSuccessed)
    {
        NSLog(@"Ground Station Open Successed");
    }
    else
    {
        NSLog(@"Ground Station Open Failed:%d", (int)result.error);
    }
}

-(void) onGroundStationCloseWithResult:(GroundStationExecuteResult*)result
{
    if (result.executeStatus == GSExecStatusBegan) {
        
    }
    else if (result.executeStatus == GSExecStatusSuccessed)
    {
        
    }
    else
    {
        
    }
}


-(void) onGroundStationUploadTaskWithResult:(GroundStationExecuteResult*)result
{
    if (result.executeStatus == GSExecStatusBegan) {
        NSLog(@"Upload Task Began");
    }
    else if (result.executeStatus == GSExecStatusSuccessed)
    {
        NSLog(@"Upload Task Success");
    }
    else
    {
        NSLog(@"Upload Task Failed: %d", (int)result.error);
    }
}




@end