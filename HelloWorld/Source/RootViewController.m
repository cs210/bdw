#import "RootViewController.h"
#import "HelloWorldDataSource.h"
#import "SpeechController.h"


// todo integrate with the RootViewController
typedef enum
{
    kListening,
    kNotListening
} listeningStates;

@interface RootViewController() <SpeechDelegate>
{
    SpeechController * speechController;
    listeningStates _currentState;
}


@property (assign) ConnectionState connectionState;
@property (assign) RemoteApplicationState remoteApplicationState;
@property (strong) id clickCountObserver;


@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastHeardWord; // TODO check connections


@end

@implementation RootViewController

/* voice control stuff */

- (IBAction)microphoneClick:(UIButton *)sender
{
    if (_currentState == kNotListening)
    {
        _statusLabel.text = @"Listening";
        [speechController startListening];
        _currentState = kListening;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    speechController = [[SpeechController alloc] initWithDelegate:self];
    [speechController setupSpeechHandler];
    
    _currentState = kNotListening;
    [self.navBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor], NSShadowAttributeName : [NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] }];
    [self updateConnectionState:self.connectionState];
    [self updateRemoteApplicationState:self.remoteApplicationState];
    
    //Set up the UI
    //Get the location of the microphone and add a
}

-(NSArray * ) listOfWordsToDetect
{
    return @[@"ACTIVATE DRONE", @" FIND PARKING", @"TEST", @"MIKE", @"OK BMW", @"GO", @"RIGHT", @"LEFT", @"SHAURYA"];
}

-(void) didReceiveWord: (NSString *) word
{
    _lastHeardWord.text = word;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


/* BMW stuff */
- (void)awakeFromNib
{
    self.connectionState = ConnectionStateNotConnectedToVehicle;
    self.remoteApplicationState = RemoteApplicationStateStopped;
    [[HelloWorldDataSource sharedDataSource] addObserver:self forKeyPath:DataSourceClickCountKey options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
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
