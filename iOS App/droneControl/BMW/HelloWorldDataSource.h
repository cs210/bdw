//
//  Copyright (c) 2012 BMW AG. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DataSourceClickCountKey;
extern NSString *const DataSourceMostRecentWordKey;

@interface HelloWorldDataSource : NSObject

@property (readonly, assign) NSUInteger clickCount;
@property (readonly, assign) NSString* mostRecentWord;

+ (HelloWorldDataSource *)sharedDataSource;

- (void)increaseClickCount;
- (void)set_MostRecentWord:(NSString *)mostRecentWord;

@end
