//
//  DroneController.m
//  droneControl
//
//  Created by Ellen Sebastian on 4/13/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "DroneController.h"

@implementation DroneController
    -(void)lookForParking{
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.9
                                                  target:self
                                                selector:@selector(moveDrone)
                                                userInfo:nil
                                                 repeats:YES];
        
    }

-(void) moveDrone{
    CLLocationCoordinate2D location;
    location.longitude = _userLocation.coordinate.longitude + (0.0001 * (float) _n_times_moved);
    location.latitude = _userLocation.coordinate.latitude + (0.0001 * (float) _n_times_moved);
    
    if (_n_times_moved > 10){
        [self.delegate updateDroneLocation:&location];
        [_timer invalidate];
        
        // transition to the NavigationViewController (however we will navigate to the space)
        [self.delegate goToNavigation:location];
        return;
        
    }
    _n_times_moved += 1;
    [self.delegate updateDroneLocation:&location];
}

@end

