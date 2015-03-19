//
//  HelloWorldViewController.h
//  droneControl
//
//  Created by BDW on 2015-03-11.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "FindParkingView.h"
#import "LastUserModeDelegate.h"

@interface HelloWorldViewController : NSObject

- (id)initWithView:(IDView *)theView;

@property (strong) HelloWorldView *view;
@property (weak, readwrite) id<LastUserModeDelegate> lumDelegate;

@end
