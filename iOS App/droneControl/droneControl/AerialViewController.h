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
#import <GoogleMaps/GoogleMaps.h>

#define USING_GMAPS 1
//#define DRONE_GPS_TEST 0

@interface AerialViewController : UIViewController <DroneDelegate,  MKMapViewDelegate, CLLocationManagerDelegate, UISplitViewControllerDelegate>

#ifdef USING_GMAPS
@property (nonatomic, strong) GMSMapView *googleMapView;
#else
@property (nonatomic, strong) MKMapView *mapView;
#endif

@property (nonatomic, strong) MKPointAnnotation *droneAnnotation;
@property (nonatomic, strong) DroneController* drone;
@property (nonatomic) bool didStartLooking; // true if the drone started looking for parking
@property (nonatomic) CLLocationCoordinate2D parkingSpace; // only defined if a parking space has been found.
@property (nonatomic) bool shouldShowMaster;
// update the location of the drone icon on the map
- (void) updateDroneLocation: (CLLocationCoordinate2D *)location;

// receive and analyze an image from the drone. This may cause goToNavigation to be called.
- (void) receiveImage: (UIImage *)image;

// open up Apple Maps navigation to destination. 
- (void) goToNavigation: (CLLocationCoordinate2D)destination;

-(void) showParkingLotConfirmationWithTitle:(NSString *)title;

-(void) userDidClickOnSpot: (CLLocationCoordinate2D) spot;

-(void) showMap;

@end

