//
//  TransparentTouchView.h
//  droneControl
//
//  Created by Michael Weingert on 2015-05-07.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransparentTouchView.h"
#import "CoordinatePointTuple.h"
#import "AerialViewController.h"
#import "DJIDroneHelper.h"
#import "LocationManager.h"

@class AerialViewController;

@interface TransparentTouchView : UIView

/*!
 * @brief A weak reference to the AerialViewController
 */
@property (nonatomic, readwrite, weak) AerialViewController * delegate;

/*!
 * @brief The array of calibrated pixel point tuples
 */
@property NSArray * coordinatePointTuples;

/*!
 * @brief A reference to the DJI drone helper class
 */
@property DJIDroneHelper * droneHelper;

/*!
 * @discussion Public method called when touch events are captured on this view
 * @param touches The set of recorded touches
 * @param event Information about the touch event
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/*!
 * @discussion A helper method to inject touches for debugging purposes
 * @param yaw Injected yaw value
 * @param altitude Injected altitude value
 * @param x Injected x touch value
 * @param x Injected y touch value
 * @param aerialController Reference to the Aerial view controller 
 * @param width Width of the superview
 * @param height Height of the superview
 */
- (void) insertArticifialTouchWithYaw:(float)yaw
                             altitude:(float)altitude
                                    X:(float)x
                                    Y:(float)y
                     aerialController:(AerialViewController *)aerialController
                            viewWidth:(float)width
                           viewHeight:(float)height;

@end
