//
//  ParkingLot.h
//  droneControl
//
//  Created by Ellen Sebastian on 4/24/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

@interface ParkingLot : NSObject{
@public
    CLLocationCoordinate2D coordinate;
    CLLocationCoordinate2D upperLeft; // upperLeft and lowerRight represent the area occupied by the parking lot.
    CLLocationCoordinate2D lowerRight;
    NSString *name;
};
@end