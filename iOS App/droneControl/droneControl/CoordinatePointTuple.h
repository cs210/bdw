//
//  CoordinatePointTuple.h
//  droneControl
//
//  Created by Michael Weingert on 2015-05-06.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class CoordinatePointTuple
 @abstract A helper class to hold an information about an x, y pixel location
 @discussion Pixel locations need to be transformed into GPS coordinates so that the point a user clicks on in an image can be added onto the map object. After a long camera calibration process, x,y pixel locations were transformed into real x and y offsets given a camera height. However, this camera calibration only occurred at a finite number of points. Thus, tuples exist for each point that was calibrated. Click locations are transformed according to the nearest tuple.
 */
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
