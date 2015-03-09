#import "RootViewController.h"
#import "HelloWorldDataSource.h"


@interface RootViewController ()

@property (assign) ConnectionState connectionState;
@property (assign) RemoteApplicationState remoteApplicationState;
@property (strong) id clickCountObserver;

@end

@implementation RootViewController

- (void)awakeFromNib
{
    self.connectionState = ConnectionStateNotConnectedToVehicle;
    self.remoteApplicationState = RemoteApplicationStateStopped;
    [[HelloWorldDataSource sharedDataSource] addObserver:self forKeyPath:DataSourceClickCountKey options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor], NSShadowAttributeName : [NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] }];
    [self updateConnectionState:self.connectionState];
    [self updateRemoteApplicationState:self.remoteApplicationState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)handleClickCountButton
{
    [[HelloWorldDataSource sharedDataSource] increaseClickCount];
}

- (void)updateConnectionState:(ConnectionState)state
{
    if (state == self.connectionState)
    {
        return;
    }

    self.connectionState = state;
    NSString *stateString = @"";

    switch (state) {
        case ConnectionStateConnectedToVehicle:
            stateString = @"connected";
            break;
        case ConnectionStateNotConnectedToVehicle:
            stateString = @"disconnected";
            break;
        default:
            stateString = @"unknown";
            break;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        self.connectionStateLabel.text = stateString;
    });
}

- (void)updateRemoteApplicationState:(RemoteApplicationState)state
{
    if (state == self.remoteApplicationState)
    {
        return;
    }

    self.remoteApplicationState = state;
    NSString *stateString = @"";

    switch (state) {
        case RemoteApplicationStateStarting:
            stateString = @"starting ...";
            break;
        case RemoteApplicationStateStarted:
            stateString = @"started";
            break;
        case RemoteApplicationStateStopping:
            stateString = @"stopping ...";
            break;
        case RemoteApplicationStateStopped:
            stateString = @"stopped";
            break;
        default:
            stateString = @"unknown";
            break;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        self.remoteApplicationStateLabel.text = stateString;
    });
}

- (void)updateRemoteClickCount:(NSNumber *)clickCount
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([clickCount compare:@0] == NSOrderedDescending) {
            [self.clickCountButton setTitle:[NSString stringWithFormat:@"Clicked %@ %@!", clickCount, [clickCount compare:@1] == NSOrderedSame ? @"time" : @"times"] forState:UIControlStateNormal];
        }
    });
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:DataSourceClickCountKey])
    {
        [self updateRemoteClickCount:[change valueForKey:NSKeyValueChangeNewKey]];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
