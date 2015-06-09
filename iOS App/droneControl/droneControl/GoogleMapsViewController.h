
//
//  GoogleMapsViewController.h
//  droneControl
//
//  Created by Ellen Sebastian on 6/6/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

/*!
 @class GoogleMapsViewController
 @abstract A wrapper class around a google map view
 @discussion This class is a UIViewController whose view is a GSMapView. 
 */

@interface GoogleMapsViewController : UIViewController

@property (nonatomic, strong) GMSMapView *googleMapView;

@end