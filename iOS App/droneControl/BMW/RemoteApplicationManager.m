//
//  RemoteApplicationManager.m
//  droneControl
//
//  Created by BDW on 2015-03-11.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "RemoteApplicationManager.h"

#import "ConnectedDroneHmiProvider.h"
#import "ConnectedDroneIdentifiers.h"
#import "BMWConnectedDroneViewController.h"
#import "AppDelegate.h"


@interface RemoteApplicationManager()

@property (assign, readwrite) RemoteApplicationState remoteApplicationState;

@property (strong) IDApplication *idApplication;
@property (strong) ConnectedDroneHmiProvider *hmiProvider;
@property (strong) BMWConnectedDroneViewController *bmwconnectedDroneViewController;

@end

#pragma mark -

@implementation RemoteApplicationManager

- (id)init
{
    self = [super init];
    if (self)
    {
        _remoteApplicationState = RemoteApplicationStateStopped;

        _hmiProvider = [ConnectedDroneHmiProvider new];
        _idApplication = [[IDApplication alloc] initWithHmiProvider:_hmiProvider];
        _idApplication.delegate = self;
        _idApplication.dataSource = self;

        _bmwconnectedDroneViewController = [[BMWConnectedDroneViewController alloc] initWithView:[_hmiProvider viewForId:IDBMWFindParkingViewId]];
    }
    return self;
}

#pragma mark - Public methods

- (void)startRemoteApplication
{
    self.remoteApplicationState = RemoteApplicationStateStarting;

    __weak id weakSelf = self;
    [self.idApplication startWithCompletionBlock:^(NSError *error) {
        RemoteApplicationManager *manager = (RemoteApplicationManager *)weakSelf;
        if (error)
        {
            manager.remoteApplicationState = RemoteApplicationStateStopped;
            return;
        }
        
        if ([manager.lumDelegate shouldFocusInRemoteHmi])
        {
            [manager.idApplication performLastUserModeWithView:[manager.hmiProvider viewForId:IDBMWFindParkingViewId]];
        }

        manager.remoteApplicationState = RemoteApplicationStateStarted;
    }];
}

- (void)stopRemoteApplication
{
    self.remoteApplicationState = RemoteApplicationStateStopping;

    __weak id weakSelf = self;
    [self.idApplication stopWithCompletionBlock:^{
        RemoteApplicationManager *manager = (RemoteApplicationManager *)weakSelf;
        manager.remoteApplicationState = RemoteApplicationStateStopped;
    }];
}

#pragma mark - IDApplicationDelegate protocol implementation

- (void)applicationRestoreMainHmiState:(IDApplication *)application
{
    [self.idApplication performLastUserModeWithView:[self.hmiProvider viewForId:IDBMWFindParkingViewId]];
}

#pragma mark - IDApplicationDataSource protocol implementation

- (NSDictionary *)manifestForApplication:(IDApplication *)application
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"ConnectedDrone" withExtension:@"plist"];
    return [NSDictionary dictionaryWithContentsOfURL:url];
}

- (NSData *)hmiDescriptionForApplication:(IDApplication *)application
{
    return [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ConnectedDrone_HMI" withExtension:@"xml"]];
}

- (NSArray *)imageDatabasesForApplication:(IDApplication *)application
{
    return [NSArray arrayWithObject:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ConnectedDrone_common_Images" withExtension:@"zip"]]];
}

@end
