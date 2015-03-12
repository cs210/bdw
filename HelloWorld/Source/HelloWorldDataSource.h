//
//  Copyright (c) 2012 BMW AG. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DataSourceClickCountKey;

@interface HelloWorldDataSource : NSObject

@property (readonly, assign) NSUInteger clickCount;

+ (HelloWorldDataSource *)sharedDataSource;

- (void)increaseClickCount;

@end
