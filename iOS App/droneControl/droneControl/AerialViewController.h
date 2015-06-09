//
//  AerialViewController.m
//  droneControl
//
//  Created by Ellen Sebastian on 4/12/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//
#import "GoogleMapsViewController.h"
#import "DJICameraViewController.h"
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

/*!
 @class AerialViewController
 @abstract Combined Google Map view and drone live video feed.
 @discussion The AerialViewController displays a GoogleMapsViewController in the 
 upper-left quadrant of the screen, and a live video feed from the drone in the rest of the screen.
 The user is prompted to touch a parking space. When the user touches the drone video feed, 
 the touch location is translated into a GPS coordinate. The user is asked for a confirmation, 
 and the app transitions to 

 */

@interface AerialViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

/*!
 * @brief A reference to the Google maps view controller that hosts the map
 */
@property (nonatomic, strong) GoogleMapsViewController *GMViewController;

/*!
 * @brief Drone annotation for apple maps
 */
@property (nonatomic, strong) MKPointAnnotation *droneAnnotation;

/*!
 * @brief A reference to parking space selected by a user
 */
@property (nonatomic) CLLocationCoordinate2D parkingSpace; // only defined if a parking space has been found.

/*!
 * @brief The UIView that captures touch events on the camera view
 */
@property UIView * dummyTouchView;

/*!
 * @brief A reference to the camera view controller that displays the drone's camer afeed
 */
@property DJICameraViewController* cameraFeed;

/*!
 * @brief A property to fix a bug with displaying the users location as 0,0
 */
@property bool firstLocationUpdate;

/*!
 * @brief A reference to the parking lot view (for sending to the parking spot fill algorithm)
 */
@property UIImageView * parkingLotView;

/*!
 * @discussion Display polylines on the map to direct the user to their destination
 * @param destination The destination to direct the user to
 */
- (void) goToNavigation: (CLLocationCoordinate2D)destination;

/*!
 * @discussion Show on the map the spot the user clicked on
 * @param spot The parking spot (coordinate) the user clicked on
 */
-(void) userDidClickOnSpot: (CLLocationCoordinate2D) spot;

/*!
 * @discussion Highlight the spot the user clicked on (with the highlight code)
 * @param x The x location the user clicked on
 * @param y The y location the user clicked on
 */
-(void) highlightTouchedUserSpot:(float) x withY:(float) y;

/*!
 * @discussion Show the map (if it was hidden)
 */
-(void) showMap;

@end

