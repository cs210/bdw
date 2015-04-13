//
//  DroneController.h
//  droneControl
//
//  Created by Ellen Sebastian on 4/13/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@protocol DroneDelegate <NSObject>
@required
// update the location of the drone icon on the map
- (void) updateDroneLocation: (CLLocationCoordinate2D *)location;

// receive and analyze an image from the drone. This may cause goToNavigation to be called.
- (void) receiveImage: (UIImage *)image;

// open up Apple Maps navigation to destination.
- (void) goToNavigation: (CLLocationCoordinate2D)destination;
@end
// Protocol Definition ends here
@interface DroneController : NSObject

{
    // Delegate to respond back
    id <DroneDelegate> _delegate;
    
}
@property (nonatomic,strong) id delegate;

-(void)lookForParking;

@end