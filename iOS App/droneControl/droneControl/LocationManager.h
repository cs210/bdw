//
//  LocationManager.h
//  droneControl
//
//  Created by Michael Weingert on 2015-05-23.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol LocationManagerProtocol

-(void) locationManagerDidUpdateLocation: (NSArray *)locations;

@end

@interface LocationManager : NSObject < CLLocationManagerDelegate >

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (instancetype)sharedManager;

-(void) subscribeToLocationEvents: (id<LocationManagerProtocol>) newSubscriber;

-(CLLocation *) getUserLocation;

@end
