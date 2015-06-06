//
//  ParkingSpotAnnotation.m
//  droneControl
//
//  Created by Ellen Sebastian on 5/8/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "ParkingSpotAnnotation.h"

@implementation ParkingSpotAnnotation

-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                   image:(NSString *)paramImage
{
    self = [super init];
    if(self != nil)
    {
        _coordinate = paramCoordinates;
        _image = paramImage;
    }
    return (self);
}

@end