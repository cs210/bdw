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

@protocol ParkingLotFinderDelegate
-(void) didUpdateLots;
-(void) lotOrderChanged;
@end

@interface ParkingLotFinder : NSObject

+ (id)sharedManager;

// should be called off the main thread as it needs to wait for http results.
-(void) setLocation: (CLLocationCoordinate2D)userLocation radius:(int)radius;

-(NSMutableArray *) getLots;

-(void) registerForLotUpdates: (id<ParkingLotFinderDelegate>) newListener;

-(void) updateLotsWithLocation: (CLLocation *) userLocation;

@end