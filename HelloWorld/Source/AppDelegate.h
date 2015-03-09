#import <UIKit/UIKit.h>
#import "RootViewController.h"


@class RemoteApplicationManager;
@class IDAccessoryMonitor;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong) RemoteApplicationManager *manager;
@property (strong) IDAccessoryMonitor *accessoryMonitor;

@end
