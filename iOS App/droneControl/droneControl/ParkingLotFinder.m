//
//  ParkingLotFinder.m
//  droneControl
//
//  Created by Ellen Sebastian on 4/23/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParkingLotFinder.h"
#import "ParkingLot.h"

@implementation ParkingLotFinder
    // dummy implememtation that returns 5 rando locations within the radius.
+(NSMutableArray*) parkingLotsNearby: (CLLocationCoordinate2D)userLocation radius:(int)radius{
    NSMutableArray* lots = [[NSMutableArray alloc] initWithCapacity:5]; // in real implementation, will get number of lots from google
    for (int i = 0; i < 5; i++){
        double dist = (int) abs( (int) arc4random()) % radius;
        double bearing = (int) arc4random() % 360; // degrees
        CLLocationCoordinate2D loc = [self coordinateFromCoord:userLocation atDistanceKm:dist / 1000.0 atBearingDegrees:bearing ];
        ParkingLot *pl = [[ParkingLot alloc] init];
        pl->lowerRight = loc;
        CLLocationCoordinate2D lowerRight;
        lowerRight.latitude = loc.latitude - 0.001;
        lowerRight.longitude = loc.longitude + 0.001;
        pl->lowerRight = lowerRight;
        CLLocationCoordinate2D upperLeft;
        lowerRight.latitude = loc.latitude + 0.001;
        lowerRight.longitude = loc.longitude - 0.001;
        pl->lowerRight = upperLeft;
        pl->name = [NSString stringWithFormat:@"%@ %@", @"parking lot" ,[NSString stringWithFormat:@"%d", i]];
        [lots addObject:pl];
    }
    return lots;
}


// lol code from stackoverflow for generating random coordinates x / y meters away
// http://stackoverflow.com/questions/6633850/calculate-new-coordinate-x-meters-and-y-degree-away-from-one-coordinate
+ (double)radiansFromDegrees:(double)degrees
{
    return degrees * (M_PI/180.0);
}

+ (double)degreesFromRadians:(double)radians
{
    return radians * (180.0/M_PI);
}

+ (CLLocationCoordinate2D)coordinateFromCoord:(CLLocationCoordinate2D)fromCoord
                                 atDistanceKm:(double)distanceKm
                             atBearingDegrees:(double)bearingDegrees
{
    double distanceRadians = distanceKm / 6371.0;
    //6,371 = Earth's radius in km
    double bearingRadians = [self radiansFromDegrees:bearingDegrees];
    double fromLatRadians = [self radiansFromDegrees:fromCoord.latitude];
    double fromLonRadians = [self radiansFromDegrees:fromCoord.longitude];
    
    double toLatRadians = asin( sin(fromLatRadians) * cos(distanceRadians)
                               + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians) );
    
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                 * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                 - sin(fromLatRadians) * sin(toLatRadians));
    
    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;
    
    CLLocationCoordinate2D result;
    result.latitude = [self degreesFromRadians:toLatRadians];
    result.longitude = [self degreesFromRadians:toLonRadians];
    return result;
}
@end