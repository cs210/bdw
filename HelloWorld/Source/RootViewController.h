#import <UIKit/UIKit.h>
#import "RemoteApplicationManager.h"
#import "SpeechController.h"

typedef enum {
    ConnectionStateUnknown = 0,
    ConnectionStateNotConnectedToVehicle = 1,
    ConnectionStateConnectedToVehicle = 2,
} ConnectionState;

@interface RootViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *connectionStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remoteApplicationStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickCountButton;

- (IBAction)handleClickCountButton;
- (void)updateConnectionState:(ConnectionState)state;
- (void)updateRemoteApplicationState:(RemoteApplicationState)state;

@end
