//
//  AerialViewController.m
//  droneControl
//
//  Created by Ellen Sebastian on 4/12/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//
#import "GoogleMapsViewController.h"
#import "DroneController.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

#define USING_GMAPS 1
//#define DRONE_GPS_TEST 0
//#define PARKING_SPOT_FILL 1
#define GOOGLE_DRECTIONS_SERVER_KEY @"AIzaSyBoy7wXWA4CkYPQ2iMfnmQJ6cz_aTE7B8I";
#define GOOGLE_DIRECTIONS_IOS_KEY @"AIzaSyAWvZ5yLxkfc-UVSiKNLBinnnJD-fIH38w"; // verified, either of these keys works.
//#define SPLITSCREENWITHDRONE 1
#define MAP_POPOVER 1
// url e.g. https://maps.googleapis.com/maps/api/directions/json?origin=37.434025,%20-122.172418&destination=37.434872,%20-122.173067&region=com&key=AIzaSyAWvZ5yLxkfc-UVSiKNLBinnnJD-fIH38w
@interface AerialViewController : UIViewController <DroneDelegate,  MKMapViewDelegate, CLLocationManagerDelegate, UISplitViewControllerDelegate>

#ifdef USING_GMAPS
@property (nonatomic, strong) GoogleMapsViewController *GMViewController;
#else
@property (nonatomic, strong) MKMapView *mapView;
#endif

@property (nonatomic, strong) MKPointAnnotation *droneAnnotation;
@property (nonatomic, strong) DroneController* drone;
@property (nonatomic) CLLocationCoordinate2D parkingSpace; // only defined if a parking space has been found.
@property (retain, nonatomic) NSMutableData *apiReturnXMLData;
@property (nonatomic) NSInteger statusNbr;
@property (copy, nonatomic) NSString *hygieneResult;
@property (copy, nonatomic) NSString *currentElement;


// update the location of the drone icon on the map
- (void) updateDroneLocation: (CLLocationCoordinate2D *)location;

// receive and analyze an image from the drone. This may cause goToNavigation to be called.
- (void) receiveImage: (UIImage *)image;

// open up Apple Maps navigation to destination. 
- (void) goToNavigation: (CLLocationCoordinate2D)destination;

-(void) showParkingLotConfirmationWithTitle:(NSString *)title;

-(void) userDidClickOnSpot: (CLLocationCoordinate2D) spot;

-(void) highlightTouchedUserSpot:(float) x withY:(float) y;

-(void) showMap;

@end

