#import "AppDelegate.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "AerialViewController.h"
#import "LocationManager.h"
#import <DJISDK/DJISDK.h>
#import <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate

static NSString *const RemoteApplicationStateKeyPath = @"remoteApplicationState";
static NSString *const LoggerHostBonjourServiceNameKeyPath = @"logger_host_bonjour_service_name";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setIdleTimerDisabled:YES];
    
    [GMSServices provideAPIKey:@"AIzaSyBhGlOQOhHiPR9VPXS1QDoxCYbxB2Y5yG0"];
    
    //setup drone integration
    NSString* appKey = @"07c6b3c3b6a76db64209d4ce";
    [DJIAppManager registerApp:appKey withDelegate:self];
    
    //Start up the location manager
    [[LocationManager sharedManager] init];
    
    return YES;
}

-(void) appManagerDidRegisterWithError:(int)error
{
    NSString* message = @"Register App Failed!";
    if (error == RegisterSuccess) {
        message = @"Register App Successed!";
    }
    NSLog(@"@%@",message);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [application setIdleTimerDisabled:NO];
    
    // deregister from EAF notifications
    [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url path] rangeOfString:@"ConnectedDrone"].location == NSNotFound)
    {
        return NO;
    }
    
    for (NSDictionary *dict in [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"]) {
        if ([[dict objectForKey:@"CFBundleURLSchemes"] containsObject:[url scheme]] )
        {
            return YES;
        }
    }
    return NO;
}

@end
