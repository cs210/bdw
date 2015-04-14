#import "AppDelegate.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <BMWAppKit/BMWAppKit.h>
#import "RemoteApplicationManager.h"
#import "IDNSLoggerAppender.h"
#import "LastUserModeDelegate.h"
#import <DJISDK/DJISDK.h>


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
    
    //setup drone integration
    NSString* appKey = @"15e1f97fcf7b133c7a1b1ab7";
    [DJIAppManager registerApp:appKey withDelegate:self];
    
    
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
    
    // register for BMWAppKit specific notifications
    self.manager = [RemoteApplicationManager new];
    self.manager.lumDelegate = self;
    
    //NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;
    //[self.manager addObserver:self forKeyPath:RemoteApplicationStateKeyPath options:options context:nil];
    // BUG: above line causes an "unrecognized selector sent to instance" error.
    [self startMonitoringA4ACompatibleAccessories];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

-(void) appManagerDidRegisterWithError:(int)error
{
    NSString* message = @"Register App Failed!";
    if (error == RegisterSuccess) {
        message = @"Register App Successed!";
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Register App" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
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
    [self.manager removeObserver:self forKeyPath:RemoteApplicationStateKeyPath context:nil];
    
    // deregister from EAF notifications
    [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
    [self stopMonitoringA4ACompatibleAccessories];
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

#pragma mark - LastUserModeDelegate override

- (BOOL)shouldFocusInRemoteHmi
{
    BOOL focus = self.focusAfterStartingInRemoteHmi;
    self.focusAfterStartingInRemoteHmi = NO;
    return focus;
}

#pragma mark - Helper methods

- (void)startMonitoringA4ACompatibleAccessories
{
    __weak id weakSelf = self;
    
    // register for BMW specific notifications
    self.a4aAccessoryMonitorNetworkAccessObserver = [[NSNotificationCenter defaultCenter] addObserverForName:IDAccessoryNetworkAccessDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        BOOL isUsingNetwork = [note.userInfo[IDAccessoryUsingNetworkKey] boolValue];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isUsingNetwork];
    }];
    
    self.a4aAccessoryDidConnectObserver = [[NSNotificationCenter defaultCenter] addObserverForName:IDAccessoryDidConnectNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        AppDelegate *appDelegate = (AppDelegate *)weakSelf;
        [[appDelegate rootViewController] updateConnectionState:ConnectionStateConnectedToVehicle];
        [appDelegate.manager startRemoteApplication];
    }];
    
    self.a4aAccessoryDidDisconnectObserver = [[NSNotificationCenter defaultCenter] addObserverForName:IDAccessoryDidDisconnectNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        AppDelegate *appDelegate = (AppDelegate *)weakSelf;
        [appDelegate.manager stopRemoteApplication];
        [[appDelegate rootViewController] updateConnectionState:ConnectionStateNotConnectedToVehicle];
    }];
    
    // tell the accessory monitor to start monitoring and retain it
    self.accessoryMonitor = [IDAccessoryMonitor new];
    [self.accessoryMonitor startMonitoring];
}

- (void)stopMonitoringA4ACompatibleAccessories
{
    [self.accessoryMonitor stopMonitoring];
    self.accessoryMonitor = nil;
    
    if (self.a4aAccessoryDidConnectObserver)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self.a4aAccessoryDidConnectObserver];
        self.a4aAccessoryDidConnectObserver = nil;
    }
    
    if (self.a4aAccessoryDidDisconnectObserver)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self.a4aAccessoryDidDisconnectObserver];
        self.a4aAccessoryDidDisconnectObserver = nil;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:RemoteApplicationStateKeyPath] && [object isEqual:self.manager])
    {
        RemoteApplicationState state = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
        [[self rootViewController] updateRemoteApplicationState:state];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Helper methods

- (SpeechDisplayViewController *)rootViewController
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    UIViewController *viewController = navigationController.viewControllers[0];
    
    if ([viewController isKindOfClass:[SpeechDisplayViewController class]])
    {
        return (SpeechDisplayViewController *)viewController;
    }
    
    return nil;
}

@end
