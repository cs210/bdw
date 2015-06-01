//
//  TransparentTouchView.h
//  droneControl
//
//  Created by Michael Weingert on 2015-05-07.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AerialViewController;

@interface TransparentTouchView : UIView

@property (nonatomic, readwrite, weak) AerialViewController * delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

- (void) insertArticifialTouchWithYaw:(float)yaw
                             altitude:(float)altitude
                                    X:(float)x
                                    Y:(float)y
                     aerialController:(AerialViewController *)aerialController
                            viewWidth:(float)width
                           viewHeight:(float)height;

@end
