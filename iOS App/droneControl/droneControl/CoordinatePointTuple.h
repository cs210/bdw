//
//  CoordinatePointTuple.h
//  droneControl
//
//  Created by Michael Weingert on 2015-05-06.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinatePointTuple : NSObject

/*!
 * @brief The x pixel ratio for the tuple ( x pixel location / total pixels in image)
 */
@property (nonatomic, readwrite) float xPixelRatio;

/*!
 * @brief The y pixel ratio for the tuple ( x pixel location / total pixels in image)
 */
@property (nonatomic, readwrite) float yPixelRatio;

/*!
 * @brief The ratio between z height and x offset for the tuple
 */
@property (nonatomic, readwrite) float xzRatio;

/*!
 * @brief The ratio between z height and y offset for the tuple
 */
@property (nonatomic, readwrite) float yzRatio;

@end
