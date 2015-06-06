//
//  ParkingSpotAnnotation.h
//  droneControl
//
//  Created by Ellen Sebastian on 5/8/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ParkingSpotAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *image;


-(id)initWithCoordinates:(CLLocationCoordinate2D) paramCoordinates
                   image:(NSString *) paramImage;

@end