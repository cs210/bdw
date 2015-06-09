
#import "SpeechDisplayViewController.h"
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
@end

@implementation SpeechDisplayViewController

@end

