//
//  ParkingLotFinder.h
//  droneControl
//
//  Created by Ellen Sebastian on 4/23/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//
// this file finds parking lots around a certain location.


struct ParkingLot{
    CLLocationCoordinate2D coordinate;
    CLLocationCoordinate2D upperLeft; // upperLeft and lowerRight represent the area occupied by the parking lot.
    CLLocationCoordinate2D lowerRight;
    NSString* name;
};

@interface ParkingLotFinder : NSObject

// should be called off the main thread as it needs to wait for http results. 
-(NSArray) parkingLotsNearby: (CLLocationCoordinate2D) userLocation (Integer) radius;

@end