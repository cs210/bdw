#import <UIKit/UIKit.h>
#import "RemoteApplicationManager.h"

typedef enum {
    ConnectionStateUnknown = 0,
    ConnectionStateNotConnectedToVehicle = 1,
    ConnectionStateConnectedToVehicle = 2,
} ConnectionState;

@interface SpeechDisplayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *connectionStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remoteApplicationStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickCountButton;

- (IBAction)handleClickCountButton;
- (void)updateConnectionState:(ConnectionState)state;
- (void)updateRemoteApplicationState:(RemoteApplicationState)state;

@end
