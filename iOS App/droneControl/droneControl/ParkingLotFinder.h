//
//  ParkingLotFinder.h
//  droneControl
//
//  Created by Ellen Sebastian on 4/23/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//
// this file finds parking lots around a certain location.

#import <MapKit/MapKit.h>
#import "ParkingLot.h"
@interface ParkingLotFinder : NSObject

// should be called off the main thread as it needs to wait for http results.
+(NSMutableArray*) parkingLotsNearby: (CLLocationCoordinate2D)userLocation radius:(int)radius;

@end