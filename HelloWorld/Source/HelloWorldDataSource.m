//
//  Copyright (c) 2012 BMW AG. All rights reserved.
//

#import "HelloWorldDataSource.h"

@interface HelloWorldDataSource ()

@property (readwrite, assign) NSUInteger clickCount;

@end

NSString *const DataSourceClickCountKey = @"clickCount";

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

@end
