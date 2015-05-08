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

@property (strong, readwrite, nonatomic) DJIDrone * drone;

+ (instancetype)sharedHelper;

-(void) mainController:(DJIMainController*)mc didUpdateSystemState:(DJIMCSystemState*)state;

-(CLLocationCoordinate2D) getDroneGPS;

-(float) getDroneHeight;

-(void) onOpenButtonClicked;

-(float) getDroneYaw;

@end
