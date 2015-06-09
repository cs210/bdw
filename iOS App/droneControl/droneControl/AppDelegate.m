#import "AppDelegate.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "IDNSLoggerAppender.h"
#import "AerialViewController.h"
#import "LocationManager.h"
#import <DJISDK/DJISDK.h>
#import <GoogleMaps/GoogleMaps.h>


@interface AppDelegate () <LastUserModeDelegate>

@property (strong) id a4aAccessoryDidConnectObserver;
@property (strong) id a4aAccessoryDidDisconnectObserver;
@property (strong) id a4aAccessoryMonitorNetworkAccessObserver;
@property (assign) BOOL focusAfterStartingInRemoteHmi;
@property (strong) IDNSLoggerAppender *nsLoggerAppender;

@end

@implementation AppDelegate

static NSString *const RemoteApplicationStateKeyPath = @"remoteApplicationState";
static NSString *const LoggerHostBonjourServiceNameKeyPath = @"logger_host_bonjour_service_name";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setIdleTimerDisabled:YES];
    self.focusAfterStartingInRemoteHmi = NO;
    
    [GMSServices provideAPIKey:@"AIzaSyBhGlOQOhHiPR9VPXS1QDoxCYbxB2Y5yG0"];
    
    //setup drone integration
    NSString* appKey = @"07c6b3c3b6a76db64209d4ce";
    [DJIAppManager registerApp:appKey withDelegate:self];
    
    //Start up the location manager
    [[LocationManager sharedManager] init];
    
    // enable BMWAppKit log output
    IDLogger *logger = [IDLogger defaultLogger];
    [logger setMaximumLogLevel:IDLogLevelDebug];
    
    IDConsoleLogAppender *consoleAppender = [IDConsoleLogAppender new];
    [logger addAppender:consoleAppender];
    [consoleAppender setMaximumLogLevel:IDLogLevelWarn];
    
    NSString *bonjourHostName = [[NSUserDefaults standardUserDefaults] valueForKeyPath:LoggerHostBonjourServiceNameKeyPath];
    
    self.nsLoggerAppender = [[IDNSLoggerAppender alloc] initWithBonjourHostName:bonjourHostName];
    [self.nsLoggerAppender setMaximumLogLevel:IDLogLevelDebug];
    [logger addAppender:self.nsLoggerAppender];
    
    // register for EAF notifications to enable BMWAppKit to receive notifications from BMW accessories
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

-(void) appManagerDidRegisterWithError:(int)error
{
    NSString* message = @"Register App Failed!";
    if (error == RegisterSuccess) {
        message = @"Register App Successed!";
    }
    NSLog(@"@%@",message);
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Register App" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *bonjourHostName = [[NSUserDefaults standardUserDefaults] valueForKeyPath:LoggerHostBonjourServiceNameKeyPath];
    self.nsLoggerAppender.bonjourHostName = bonjourHostName;
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
            self.focusAfterStartingInRemoteHmi = YES;
            return YES;
        }
    }
    return NO;
}

@end
