
#import "SpeechDisplayViewController.h"
#import "BMWConnectedDroneDataSource.h"
#import "SpeechController.h"
#import "AerialViewController.h"
#import "DJICameraViewController.h"
#import <DJISDK/DJISDK.h>

typedef enum
{
    kListening,
    kNotListening
} listeningStates;



@interface SpeechDisplayViewController () <SpeechDelegate>
{
    SpeechController * speechController;
    listeningStates _currentState;
//    DJIDrone* _drone;
}

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastHeardWord;
@property (weak, nonatomic) IBOutlet UILabel *askForConfirmation;
@property (weak, nonatomic) IBOutlet UIButton *mic_button;

@property (assign) ConnectionState connectionState;
@property (assign) RemoteApplicationState remoteApplicationState;
@property (strong) id clickCountObserver;
@property bool needConfirmation; // true if the user said FIND PARKING and we want to hear YES. false otherwise

@end

@implementation SpeechDisplayViewController

//    BOOL _gimbalAttitudeUpdateFlag;


/* speech stuff */

- (IBAction)microphoneClicked:(UIButton *)sender
{
    if (_currentState == kNotListening)
    {
        _statusLabel.text = @"Listening";
        [speechController startListening];
        _currentState = kListening;
        NSLog(@"Status: listening");
    }
//    [self.navigationController pushViewController:[[AerialViewController alloc] init] animated:NO];
    
}
- (IBAction)parking_button:(id)sender
{
    [self moveToNext];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"APPEAR");
    self.mic_button.alpha = 1.0f;
    [UIView animateWithDuration:1.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionRepeat |
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.mic_button.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                     }];
//    [_drone connectToDrone];
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
    
    self.mic_button.alpha = 1.0f;
    [UIView animateWithDuration:1.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionRepeat |
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.mic_button.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                     }];
    
    //Set up the UI
    //Get the location of the microphone and add a
    
    //setup drone
//    _drone = [[DJIDrone alloc] initWithType:DJIDrone_Phantom];
//    _drone.gimbal.delegate = self;
}

-(NSArray * ) listOfWordsToDetect
{
    return @[@"ACTIVATE DRONE", @"FIND PARKING", @"YES", @"NO", @"TEST", @"MIKE", @"OK BMW", @"GO", @"RIGHT", @"LEFT", @"SHAURYA"];
}

-(void) didReceiveWord: (NSString *) word
{

    NSLog(@"Word heard:%@", word);
//    [self.navigationController pushViewController:[[AerialViewController alloc] init] animated:NO];
//    DJICamerViewController* cameraFeed = [[DJICamerViewController alloc] initWithNibName:@"DJICameraViewController" bundle:nil];
//    [self.navigationController pushViewController:cameraFeed animated:NO];


    [[BMWConnectedDroneDataSource sharedDataSource] set_MostRecentWord:word];
    _lastHeardWord.text = word;
    if ([word containsString:@"FIND PARKING"]){
        _needConfirmation = true;
        _askForConfirmation.hidden = NO;
        NSLog(@"Needs confirmation");
    }
    if ([word isEqualToString:@"NO"]){
        _askForConfirmation.hidden = YES;
        _needConfirmation = false;
        NSLog(@"No needs confirmation");

    }
    if ([word containsString:@"YES"] && _needConfirmation){
        _askForConfirmation.hidden = YES;
        
//For now transition to other view controller
//        [self.navigationController pushViewController:[[AerialViewController alloc] init] animated:NO];
        [self moveToNext];
        

//        [self.navigationController pushViewController:[[AerialViewController alloc] init] animated:NO];

    }
    
}

-(void) moveToNext
{
    [speechController stopListening];
//    [self onGimbalAttitudeScrollDown];
    NSLog(@"Moving gimbal and then to next view controller");
    //DJICameraViewController* cameraFeed = [[DJICameraViewController alloc] initWithNibName:@"DJICameraViewController" bundle:nil];
//    cameraFeed._drone = _drone;
    // THIS LINE FOR TESTING AERIALVIEWCONTROLLER STUFF
    [self.navigationController pushViewController:[[AerialViewController alloc] init] animated:NO];

    //[self.navigationController pushViewController:cameraFeed animated:NO];
}

//-(void) dealloc
//{
//    [_drone destroy];
//}

//-(void) viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    //gimabl
//    [_drone disconnectToDrone];
//    [_drone destroy];
//}


//-(void) onGimbalAttitudeScrollDown
//{
//    DJIGimbalRotation pitch = {YES, 150, RelativeAngle, RotationBackward};
//    DJIGimbalRotation roll = {NO, 0, RelativeAngle, RotationBackward};
//    DJIGimbalRotation yaw = {YES, 0, RelativeAngle, RotationBackward};
//    
//    pitch.angle = 300;
//    roll.angle = 0;
//    yaw.angle = 0;
//    
//    [_drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
//        if (error.errorCode == ERR_Successed) {
//            
//        }
//        else
//        {
//            NSLog(@"Set GimbalAttitude Failed");
//        }
//    }];
//    [self readGimbalAttitude];
//}
//
//-(void) readGimbalAttitude
//{
//    DJIGimbalAttitude attitude = _drone.gimbal.gimbalAttitude;
//    NSLog(@"Gimbal Atti Pitch:%d, Roll:%d, Yaw:%d", attitude.pitch, attitude.roll, attitude.yaw);
//}


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
