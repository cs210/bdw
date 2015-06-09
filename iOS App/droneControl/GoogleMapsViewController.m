//
//  GoogleMapsViewController.m
//  droneControl
//
//  Created by Ellen Sebastian on 6/6/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//
#import "GoogleMapsViewController.h"
#import <Foundation/Foundation.h>

@implementation GoogleMapsViewController
{
    bool _firstLocationUpdate;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    [_googleMapView addObserver:self
                     forKeyPath:@"myLocation"
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _googleMapView.myLocationEnabled = YES; // THIS DOES NOT WORK
    });
    
    _googleMapView.settings.myLocationButton = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (!_firstLocationUpdate)
    {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        _firstLocationUpdate = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _googleMapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:17];
    }
}

@end