//
//  CoordinatePointTuple.h
//  droneControl
//
//  Created by Michael Weingert on 2015-05-06.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinatePointTuple : NSObject

@property (nonatomic, readwrite) float xPixelRatio;
@property (nonatomic, readwrite) float yPixelRatio;
@property (nonatomic, readwrite) float xzRatio;
@property (nonatomic, readwrite) float yzRatio;

@end
