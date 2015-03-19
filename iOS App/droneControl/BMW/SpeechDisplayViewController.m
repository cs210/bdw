
#import "SpeechDIsplayViewController.h"
#import "BMWConnectedDroneDataSource.h"
#import "SpeechController.h"
#import "SimulatedNavigationViewController.h"

typedef enum
{
    kListening,
    kNotListening
} listeningStates;



@interface SpeechDisplayViewController () <SpeechDelegate>
{
    SpeechController * speechController;
    listeningStates _currentState;
}

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastHeardWord;
@property (weak, nonatomic) IBOutlet UILabel *askForConfirmation;

@property (assign) ConnectionState connectionState;
@property (assign) RemoteApplicationState remoteApplicationState;
@property (strong) id clickCountObserver;
@property bool needConfirmation; // true if the user said FIND PARKING and we want to hear YES. false otherwise

@end

@implementation SpeechDisplayViewController



/* speech stuff */




- (IBAction)microphoneClicked:(UIButton *)sender
{
    if (_currentState == kNotListening)
    {
        _statusLabel.text = @"Listening";
        [speechController startListening];
        _currentState = kListening;
    }
    [self.navigationController pushViewController:[[SimulatedNavigationViewController alloc] init] animated:NO];
    
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
    
    // Do any additional setup after loading the view, typically from a nib.
    speechController = [[SpeechController alloc] initWithDelegate:self];
    [speechController setupSpeechHandler];
    
    _currentState = kNotListening;
    
    //Set up the UI
    //Get the location of the microphone and add a
}

-(NSArray * ) listOfWordsToDetect
{
    return @[@"ACTIVATE DRONE", @" FIND PARKING", @"YES", @"NO", @"TEST", @"MIKE", @"OK BMW", @"GO", @"RIGHT", @"LEFT", @"SHAURYA"];
}

-(void) didReceiveWord: (NSString *) word
{
    [[BMWConnectedDroneDataSource sharedDataSource] set_MostRecentWord:word];
    _lastHeardWord.text = word;
    if ([word isEqualToString:@"FIND PARKING"]){
        _needConfirmation = true;
        _askForConfirmation.hidden = NO;
        NSLog(@"Needs confirmation");
    }
    if ([word isEqualToString:@"NO"]){
        _askForConfirmation.hidden = YES;
        _needConfirmation = false;
        NSLog(@"No needs confirmation");

    }
    if ([word isEqualToString:@"YES"] && _needConfirmation){
        _askForConfirmation.hidden = YES;
        //For now transition to other view controller
        [self.navigationController pushViewController:[[SimulatedNavigationViewController alloc] init] animated:NO];
    }
    
}




- (void)awakeFromNib
{
    self.connectionState = ConnectionStateNotConnectedToVehicle;
    self.remoteApplicationState = RemoteApplicationStateStopped;
    [[BMWConnectedDroneDataSource sharedDataSource] addObserver:self forKeyPath:DataSourceClickCountKey options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (IBAction)handleClickCountButton
{
    [[BMWConnectedDroneDataSource sharedDataSource] increaseClickCount];
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
