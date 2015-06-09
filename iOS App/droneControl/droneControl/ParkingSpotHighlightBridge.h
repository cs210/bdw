//
//  ParkingSpotHighlightBridge.h
//  droneControl
//
//  Created by Michael Weingert on 2015-06-02.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ParkingSpotHighlightBridge : NSObject

/*!
 * @discussion Highlight clicked-on parking spots based off an image and click location
 * @param droneImage The base image that has been clicked on
 * @param x The x location the user has clicked on
 * @param y The y location the user has clicked on
 */
+(UIImage *) initWithUIImage: (UIImage *) droneImage andClickX:(float)x andClickY:(float)y;

/*!
 * @discussion Return a new image after scaling and cropping the original image to fit the new size
 * @param source The source image to scale and crop
 * @param targetSize The new size that we are scaling and cropping to
 */
+(UIImage*)imageByScalingAndCroppingWithImage:(UIImage *)source forSize:(CGSize)targetSize;

@end
