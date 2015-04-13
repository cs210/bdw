//
//  AerialViewController.m
//  droneControl
//
//  Created by Ellen Sebastian on 4/12/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface AerialViewController : UIViewController


// update the location of the drone icon on the map
- (void) updateDroneLocation: (CLLocationCoordinate2D *)location;

// receive and analyze an image from the drone. This may cause goToNavigation to be called.
- (void) receiveImage: (UIImage *)image;

// open up Apple Maps navigation to destination. 
- (void) goToNavigation: (CLLocationCoordinate2D)destination;
@end

