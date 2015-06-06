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

+(UIImage *) initWithUIImage: (UIImage *) droneImage andClickX:(float)x andClickY:(float)y;

+(UIImage*)imageByScalingAndCroppingWithImage:(UIImage *)source forSize:(CGSize)targetSize;

@end
