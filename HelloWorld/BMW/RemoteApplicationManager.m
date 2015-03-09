#import "RemoteApplicationManager.h"

#import "HelloWorldHmiProvider.h"
#import "HelloWorldIdentifiers.h"
#import "HelloWorldViewController.h"
#import "AppDelegate.h"


@interface RemoteApplicationManager()

@property (assign, readwrite) RemoteApplicationState remoteApplicationState;

@property (strong) IDApplication *idApplication;
@property (strong) HelloWorldHmiProvider *hmiProvider;
@property (strong) HelloWorldViewController *helloWorldViewController;

@end

#pragma mark -

@implementation RemoteApplicationManager

- (id)init
{
    self = [super init];
    if (self)
    {
        _remoteApplicationState = RemoteApplicationStateStopped;

        _hmiProvider = [HelloWorldHmiProvider new];
        _idApplication = [[IDApplication alloc] initWithHmiProvider:_hmiProvider];
        _idApplication.delegate = self;
        _idApplication.dataSource = self;

        _helloWorldViewController = [[HelloWorldViewController alloc] initWithView:[_hmiProvider viewForId:IDHelloWorldViewId]];
    }
    return self;
}

#pragma mark - Public methods

- (void)startRemoteApplication
{
    self.remoteApplicationState = RemoteApplicationStateStarting;

    __weak id weakSelf = self;
    [self.idApplication startWithCompletionBlock:^(NSError *error) {
        RemoteApplicationManager *manager = (RemoteApplicationManager *)weakSelf;
        if (error)
        {
            manager.remoteApplicationState = RemoteApplicationStateStopped;
            return;
        }
        
        if ([manager.lumDelegate shouldFocusInRemoteHmi])
        {
            [manager.idApplication performLastUserModeWithView:[manager.hmiProvider viewForId:IDHelloWorldViewId]];
        }

        manager.remoteApplicationState = RemoteApplicationStateStarted;
    }];
}

- (void)stopRemoteApplication
{
    self.remoteApplicationState = RemoteApplicationStateStopping;

    __weak id weakSelf = self;
    [self.idApplication stopWithCompletionBlock:^{
        RemoteApplicationManager *manager = (RemoteApplicationManager *)weakSelf;
        manager.remoteApplicationState = RemoteApplicationStateStopped;
    }];
}

#pragma mark - IDApplicationDelegate protocol implementation

- (void)applicationRestoreMainHmiState:(IDApplication *)application
{
    [self.idApplication performLastUserModeWithView:[self.hmiProvider viewForId:IDHelloWorldViewId]];
}

#pragma mark - IDApplicationDataSource protocol implementation

- (NSDictionary *)manifestForApplication:(IDApplication *)application
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"HelloWorld" withExtension:@"plist"];
    return [NSDictionary dictionaryWithContentsOfURL:url];
}

- (NSData *)hmiDescriptionForApplication:(IDApplication *)application
{
    return [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HelloWorld_HMI" withExtension:@"xml"]];
}

- (NSArray *)imageDatabasesForApplication:(IDApplication *)application
{
    return [NSArray arrayWithObject:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HelloWorld_common_Images" withExtension:@"zip"]]];
}

@end
