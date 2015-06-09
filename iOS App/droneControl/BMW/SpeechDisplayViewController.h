//
//  SpeechDisplayViewController.h
//  droneControl
//
//  Created by BDW on 2015-03-11.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DJISDK/DJISDK.h>

typedef enum {
    ConnectionStateUnknown = 0,
    ConnectionStateNotConnectedToVehicle = 1,
    ConnectionStateConnectedToVehicle = 2,
} ConnectionState;

@interface SpeechDisplayViewController : UIViewController <DJIGimbalDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *connectionStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remoteApplicationStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickCountButton;

- (IBAction)handleClickCountButton;
- (void)updateConnectionState:(ConnectionState)state;


@end
