#import <BMWAppKit/BMWAppKit.h>

#import "LastUserModeDelegate.h"

typedef enum {
    RemoteApplicationStateUnknown = 0,
    RemoteApplicationStateStarting = 1,
    RemoteApplicationStateStarted = 2,
    RemoteApplicationStateStopping = 3,
    RemoteApplicationStateStopped = 4
} RemoteApplicationState;

@interface RemoteApplicationManager : NSObject <IDApplicationDataSource, IDApplicationDelegate>

@property (assign, readonly) RemoteApplicationState remoteApplicationState;
@property (weak, readwrite) id<LastUserModeDelegate> lumDelegate;

- (void)startRemoteApplication;
- (void)stopRemoteApplication;

@end
