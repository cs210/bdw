//
//  ParkingLot.m
//  droneControl
//
//  Created by Ellen Sebastian on 4/24/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "ParkingLot.h"
@implementation ParkingLot
    CLLocationCoordinate2D coordinate;
    CLLocationCoordinate2D upperLeft; // upperLeft and lowerRight represent the area occupied by the parking lot.
    CLLocationCoordinate2D lowerRight;
    NSString *name;
@end