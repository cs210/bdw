
//
//  LocationManager.m
//  droneControl
//
//  Created by Michael Weingert on 2015-05-23.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

+ (id)sharedManager {
    static LocationManager *sharedLocationHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationHelper = [[self alloc] init];
        [sharedLocationHelper initLocationHelper];
    });
    return sharedLocationHelper;
}

-(void) initLocationHelper
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

-(CLLocation *) getUserLocation
{
    return _locationManager.location;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // No need for this right now
}

@end
