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
{
    NSMutableArray *_lots;
    NSMutableArray *_lotListeners;
    CLLocationCoordinate2D _lastKnownLocation;
    int _radius;
}
// dummy implememtation that returns 5 rando locations within the radius.

+ (id)sharedManager {
    static ParkingLotFinder *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _lots = [[NSMutableArray alloc] initWithCapacity:5]; // in real implementation, will get number of lots from google
        _lotListeners = [NSMutableArray array];
    }
    return self;
}

-(void) registerForLotUpdates: (id<ParkingLotFinderDelegate>) newListener
{
    [_lotListeners addObject:newListener];
}


// sorry for this ugly code :( it's temporary and not worth it to use a db
-(void) findStanfordLots{
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.430632) longitude:(-122.173277) lotName:@"Gates lot"]];
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.429110) longitude:(-122.169705) lotName:@"Stanford Oval"]];
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.432808) longitude:(-122.169469) lotName:@"Cantor Museum Lot"]];
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.429460) longitude:(-122.166358) lotName:@"Memorial Auditorium Lot"]];
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.423683) longitude:(-122.161594) lotName:@"Wilbur Lot"]];
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.427756) longitude:(-122.164695) lotName:@"Encina Hall Lot"]];
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.421731) longitude:(-122.163678) lotName:@"Vaden Lot"]];
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.423316) longitude:(-122.160363) lotName:@"Mirrielees Lot"]];
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.424236) longitude:(-122.158571) lotName:@"Blackwelder Lot"]];
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.431373) longitude:(-122.176705) lotName:@"LKSC Loading Dock"]];
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.433000) longitude:(-122.173786) lotName:@"Medical School Lot"]];
    [_lots addObject:[[ParkingLot alloc] initWithCoord:(37.429993) longitude:(-122.177521) lotName:@"Jordan Quad Lot"]];
    
}

-(void) findNearbyLots
{
    for (int i = 0; i < 5; i++){
        double dist = (int) abs( (int) arc4random()) % _radius;
        double bearing = (int) arc4random() % 360; // degrees
        CLLocationCoordinate2D loc = [self coordinateFromCoord:_lastKnownLocation atDistanceKm:dist / 1000.0 atBearingDegrees:bearing ];
        ParkingLot *pl = [[ParkingLot alloc] init];
        pl->coordinate = loc;
        CLLocationCoordinate2D lowerRight;
        lowerRight.latitude = loc.latitude - 0.001;
        lowerRight.longitude = loc.longitude + 0.001;
        pl->lowerRight = lowerRight;
        CLLocationCoordinate2D upperLeft;
        upperLeft.latitude = loc.latitude + 0.001;
        upperLeft.longitude = loc.longitude - 0.001;
        pl->upperLeft = upperLeft;
        pl->name = [NSString stringWithFormat:@"%@ %@", @"parking lot" ,[NSString stringWithFormat:@"%d", i]];
        [_lots addObject:pl];
    }
}

-(void) alertAllListeners
{
    for ( id<ParkingLotFinderDelegate> listener in _lotListeners)
    {
        [listener didUpdateLots];
    }
}

-(void) setLocation: (CLLocationCoordinate2D)userLocation radius:(int)radius{
    [_lots removeAllObjects];
    _lastKnownLocation = userLocation;
    _radius = radius;
    [self findStanfordLots];
    [self alertAllListeners];
}

-(NSMutableArray *) getLots
{
    return _lots;
}

// lol code from stackoverflow for generating random coordinates x / y meters away
// http://stackoverflow.com/questions/6633850/calculate-new-coordinate-x-meters-and-y-degree-away-from-one-coordinate
- (double)radiansFromDegrees:(double)degrees
{
    return degrees * (M_PI/180.0);
}

- (double)degreesFromRadians:(double)radians
{
    return radians * (180.0/M_PI);
}

- (CLLocationCoordinate2D)coordinateFromCoord:(CLLocationCoordinate2D)fromCoord
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