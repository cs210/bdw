//
//  AerialViewController.m
//  droneControl
//
//  Created by Ellen Sebastian on 4/12/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//
#import "GoogleMapsViewController.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DJICameraViewController.h"
#import "TransparentTouchView.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "ParkingSpotHighlightBridge.h"
#import "LocationManager.h"

#define GOOGLE_DRECTIONS_SERVER_KEY @"AIzaSyBoy7wXWA4CkYPQ2iMfnmQJ6cz_aTE7B8I";
#define GOOGLE_DIRECTIONS_IOS_KEY @"AIzaSyAWvZ5yLxkfc-UVSiKNLBinnnJD-fIH38w"; // verified, either of these keys works.
#define MAP_POPOVER 1
@interface AerialViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) GoogleMapsViewController *GMViewController;
@property (nonatomic, strong) MKPointAnnotation *droneAnnotation;
@property (nonatomic) CLLocationCoordinate2D parkingSpace; // only defined if a parking space has been found.
@property UIView * dummyTouchView;
@property DJICameraViewController* cameraFeed;
@property bool firstLocationUpdate;
@property UIImageView * parkingLotView;





// open up Apple Maps navigation to destination. 
- (void) goToNavigation: (CLLocationCoordinate2D)destination;

-(void) userDidClickOnSpot: (CLLocationCoordinate2D) spot;

-(void) highlightTouchedUserSpot:(float) x withY:(float) y;

-(void) showMap;

@end

