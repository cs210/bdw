//
//  HelloWorldDataSource.m
//  droneControl
//
//  Created by BDW on 2015-03-11.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "HelloWorldDataSource.h"

@interface HelloWorldDataSource ()

@property (readwrite, assign) NSUInteger clickCount;
@property (readwrite, assign) NSString* mostRecentWord;
@end
NSString *const DataSourceClickCountKey = @"clickCount";
NSString *const DataSourceMostRecentWordKey = @"mostRecentWord";

@implementation HelloWorldDataSource

+ (HelloWorldDataSource *)sharedDataSource
{
    static HelloWorldDataSource *dataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSource = [HelloWorldDataSource new];
    });
    
    return dataSource;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _clickCount = 0;
    }
    return self;
}

- (void)increaseClickCount
{
    self.clickCount++;
}

/* the underscore is hear because I can't figure out how to get rid of warning
 "writable property cannot pair a synthesized getter with a user defined setter" */
-(void)set_MostRecentWord:(NSString *)mostRecentWord
{
    self.mostRecentWord = mostRecentWord;
}
@end
