//
//  AerialViewController.m
//  droneControl
//
//  Created by Ellen Sebastian on 4/12/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//
#import "DroneController.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface AerialViewController : UIViewController <DroneDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKPointAnnotation *droneAnnotation;
@property (nonatomic, strong) DroneController* drone;
@property (nonatomic) bool didStartLooking; // true if the drone started looking for parking
@property (nonatomic) CLLocationCoordinate2D parkingSpace; // only defined if a parking space has been found.
// update the location of the drone icon on the map
- (void) updateDroneLocation: (CLLocationCoordinate2D *)location;

// receive and analyze an image from the drone. This may cause goToNavigation to be called.
- (void) receiveImage: (UIImage *)image;

// open up Apple Maps navigation to destination. 
- (void) goToNavigation: (CLLocationCoordinate2D)destination;
@end

