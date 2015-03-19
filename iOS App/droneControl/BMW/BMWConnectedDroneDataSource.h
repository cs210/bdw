//
//  BMWConnectedDroneDataSource.m
//  droneControl
//
//  Created by BDW on 2015-03-11.
//  Copyright (c) 2015 bdw. All rights reserved.
//
#import <Foundation/Foundation.h>

extern NSString *const DataSourceClickCountKey;
extern NSString *const DataSourceMostRecentWordKey;

@interface BMWConnectedDroneDataSource : NSObject

@property (readonly, assign) NSUInteger clickCount;
@property (readonly, assign) NSString* mostRecentWord;

+ (BMWConnectedDroneDataSource *)sharedDataSource;

- (void)increaseClickCount;
- (void)set_MostRecentWord:(NSString *)mostRecentWord;

@end
