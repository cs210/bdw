//
//  AppDelegate.h
//  droneControl
//
//  Created by Michael Weingert on 2015-03-08.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechDisplayViewController.h"


@class RemoteApplicationManager;
@class IDAccessoryMonitor;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong) RemoteApplicationManager *manager;
@property (strong) IDAccessoryMonitor *accessoryMonitor;

@end

