//
//  MainControllerTestViewController.m
//  DJIVisionSDK
//
//  Created by Ares on 14-7-16.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "MainControllerTestViewController.h"

@interface MainControllerTestViewController ()

-(IBAction) onSetHomePoint1ButtonClicked:(id)sender;
-(IBAction) onSetHomePoint2ButtonClicked:(id)sender;
-(IBAction) onEnableSmartGoHomeButtonClicked:(id)sender;
-(IBAction) onDisableSmartGoHomeButtonClicked:(id)sender;
-(IBAction) onSetGoHomeDefaultAltitudeButtonClicked:(id)sender;
-(IBAction) onSetGoHomeTempAltitudeButtonClicked:(id)sender;

@end

@implementation MainControllerTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _connectionStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    _connectionStatusLabel.backgroundColor = [UIColor clearColor];
    _connectionStatusLabel.textAlignment = NSTextAlignmentCenter;
    _connectionStatusLabel.text = @"Disconnected";
    
    [self.navigationController.navigationBar addSubview:_connectionStatusLabel];
    
    self.statusTextView.editable = NO;
    
    _drone = [[DJIDrone alloc] initWithType:DJIDrone_Phantom];
    _drone.delegate = self;
    _drone.mainController.mcDelegate = self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_drone connectToDrone];
    [_drone.mainController startUpdateMCSystemState];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_connectionStatusLabel removeFromSuperview];
    [_drone.mainController stopUpdateMCSystemState];
    [_drone disconnectToDrone];
    [_drone destroy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showErrorMessage:(NSString*)message
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed" message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alertView show];
}

-(void) showSuccessed:(NSString*)message
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Successed" message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alertView show];
}

-(IBAction) onSetHomePoint1ButtonClicked:(id)sender
{
    CLLocationCoordinate2D coordinate = mLastSystemState.droneLocation;
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        [_drone.mainController setHomePoint:coordinate withResult:^(DJIError *error) {
            if (error.errorCode != ERR_Successed) {
                [self showErrorMessage:[NSString stringWithFormat:@"Set Home Point  Failed:(%@), Drone{%0.6f, %0.6f}",   error.errorDescription, coordinate.latitude, coordinate.longitude]];
            }
            else
            {
                [self showSuccessed:[NSString stringWithFormat:@"Set Home Point:{%0.6f, %0.6f}", coordinate.latitude, coordinate.longitude]];
            }
        }];
    }
    else
    {
        [self showErrorMessage:@"Drone Location is invalid"];
    }

}

-(IBAction) onSetHomePoint2ButtonClicked:(id)sender
{
    [_drone.mainController getHomePoint:^(CLLocationCoordinate2D homePoint, DJIError *error) {
        if (error.errorCode == ERR_Successed) {
            [self showSuccessed:[NSString stringWithFormat:@"Get Home:{%f, %f}", homePoint.latitude, homePoint.longitude]];
        }
        else
        {
            [self showErrorMessage:[NSString stringWithFormat:@"Get Home Failed:%d", error.errorCode]];
        }
    }];
}

-(IBAction) onEnableSmartGoHomeButtonClicked:(id)sender
{
    DJIPhantomMainController* phantomMC = (DJIPhantomMainController*)_drone.mainController;
    [phantomMC setSmartGoHomeEnable:YES withResult:^(DJIError *error) {
        if (error.errorCode == ERR_Successed) {
            [self showSuccessed:@"Set Smart Go Home Enable"];
        }
        else
        {
            [self showErrorMessage:[NSString stringWithFormat:@"Set Smart Go Home Enable:%d", error.errorCode]];
        }
    }];
}

-(IBAction) onDisableSmartGoHomeButtonClicked:(id)sender
{
    DJIPhantomMainController* phantomMC = (DJIPhantomMainController*)_drone.mainController;
    [phantomMC setSmartGoHomeEnable:NO withResult:^(DJIError *error) {
        if (error.errorCode == ERR_Successed) {
            [self showSuccessed:@"Set Smart Go Home Disable"];
        }
        else
        {
            [self showErrorMessage:[NSString stringWithFormat:@"Set Smart Go Home Disable:%d", error.errorCode]];
        }
    }];
}

-(IBAction) onSetGoHomeDefaultAltitudeButtonClicked:(id)sender
{
    [_drone.mainController setGoHomeDefaultAltitude:80.0 withResult:^(DJIError *error) {
        if (ERR_Successed == error.errorCode) {
            [self showSuccessed:@"Set Default GoHome Altitude Successed"];
        }
        else
        {
            [self showErrorMessage:[NSString stringWithFormat:@"Set Default GoHome Altitude Failed:%d", error.errorCode]];
        }
    }];
}

-(IBAction) onSetGoHomeTempAltitudeButtonClicked:(id)sender
{
    if (mLastSystemState) {
        float tempAltitude = mLastSystemState.altitude;
        [_drone.mainController setGoHomeTemporaryAltitude:tempAltitude withResult:^(DJIError *error) {
            if (error.errorCode == ERR_Successed) {
                [self showSuccessed:[NSString stringWithFormat:@"Set Temp GoHome Altitude Successed: %0.1f m", tempAltitude]];
            }
            else
            {
                [self showErrorMessage:[NSString stringWithFormat:@"Set Temp GoHome Altitude Failed:%d", error.errorCode]];
            }
        }];
    }
}

-(void) mainController:(DJIMainController*)mc didMainControlError:(MCError)error
{
    switch (error) {
        case MC_NO_ERROR:
        {
            self.errorLabel.text = @"NO Error";
            break;
        }
        case MC_CONFIG_ERROR:
        {
            self.errorLabel.text = @"Config Error";
            break;
        }
        case MC_SERIALNUM_ERROR:
        {
            self.errorLabel.text = @"SERIALNUM_ERROR";
            break;
        }
        case MC_IMU_ERROR:
        {
            self.errorLabel.text = @"IMU_ERROR";
            break;
        }
        case MC_X1_ERROR:
        {
            self.errorLabel.text = @"X1_ERROR";
            break;
        }
        case MC_X2_ERROR:
        {
            self.errorLabel.text = @"X2_ERROR";
            break;
        }
        case MC_PMU_ERROR:
        {
            self.errorLabel.text = @"PMU_ERROR";
            break;
        }
        case MC_TRANSMITTER_ERROR:
        {
            self.errorLabel.text = @"TRANSMITTER_ERROR";
            break;
        }
        case MC_SENSOR_ERROR:
        {
            self.errorLabel.text = @"SENSOR_ERROR";
            break;
        }
        case MC_COMPASS_ERROR:
        {
            self.errorLabel.text = @"COMPASS_ERROR";
            break;
        }
        case MC_IMU_CALIBRATION_ERROR:
        {
            self.errorLabel.text = @"IMU_CALIBRATION_ERROR";
            break;
        }
        case MC_COMPASS_CALIBRATION_ERROR:
        {
            self.errorLabel.text = @"COMPASS_CALIBRATION_ERROR";
            break;
        }
        case MC_TRANSMITTER_CALIBRATION_ERROR:
        {
            self.errorLabel.text = @"TRANSMITTER_CALIBRATION_ERROR";
            break;
        }
        case MC_INVALID_BATTERY_ERROR:
        {
            self.errorLabel.text = @"INVALID_BATTERY_ERROR";
            break;
        }
        case MC_INVALID_BATTERY_COMMUNICATION_ERROR:
        {
            self.errorLabel.text = @"INVALID_BATTERY_COMMUNICATION_ERROR";
            break;
        }
            
        default:
            break;
    }
}

-(void) mainController:(DJIMainController*)mc didUpdateSystemState:(DJIMCSystemState*)state
{
    NSMutableString* MCSystemStateString = [[NSMutableString alloc] init];
    
    [MCSystemStateString appendFormat:@"satelliteCount = %d\n", state.satelliteCount];
    [MCSystemStateString appendFormat:@"homeLocation = {%f, %f}\n", state.homeLocation.latitude, state.homeLocation.longitude];
    [MCSystemStateString appendFormat:@"droneLocation = {%f, %f}\n", state.droneLocation.latitude, state.droneLocation.longitude];
    [MCSystemStateString appendFormat:@"velocityX = %f\n", state.velocityX];
    [MCSystemStateString appendFormat:@"velocityY = %f\n", state.velocityY];
    [MCSystemStateString appendFormat:@"velocityZ = %f\n", state.velocityZ];
    [MCSystemStateString appendFormat:@"altitude = %f\n", state.altitude];
    [MCSystemStateString appendFormat:@"DJIaltitude  = {%f, %f , %f}\n", state.attitude.pitch ,state.attitude.roll , state.attitude.yaw];
    [MCSystemStateString appendFormat:@"powerLevel = %d\n", state.powerLevel];
    [MCSystemStateString appendFormat:@"isFlying = %d\n", state.isFlying];
    [MCSystemStateString appendFormat:@"noFlyStatus = %d\n", (int)state.noFlyStatus];
    [MCSystemStateString appendFormat:@"noFlyZoneCenter = {%f,%f}\n", state.noFlyZoneCenter.latitude,state.noFlyZoneCenter.longitude];
    [MCSystemStateString appendFormat:@"noFlyZoneRadius = %d\n", state.noFlyZoneRadius];
    [MCSystemStateString appendFormat:@"RemainTimeForFlight = %d min\n", (int)state.smartGoHomeData.remainTimeForFlight / 60];
    [MCSystemStateString appendFormat:@"timeForGoHome = %d s\n", (int)state.smartGoHomeData.timeForGoHome];
    [MCSystemStateString appendFormat:@"timeForLanding = %d s\n", (int)state.smartGoHomeData.timeForLanding];
    [MCSystemStateString appendFormat:@"powerPercentForGoHome = %d%%\n", (int)state.smartGoHomeData.powerPercentForGoHome];
    [MCSystemStateString appendFormat:@"powerPercentForLanding = %d%%\n", (int)state.smartGoHomeData.powerPercentForLanding];
    [MCSystemStateString appendFormat:@"radiusForGoHome = %d m\n", (int)state.smartGoHomeData.radiusForGoHome];
    [MCSystemStateString appendFormat:@"droneRequestGoHome = %d\n", state.smartGoHomeData.droneRequestGoHome];
    
    _statusTextView.text = MCSystemStateString;
    
    mLastSystemState = state;
    if (state.smartGoHomeData.droneRequestGoHome) {
        if (_goHomeAlertView == nil) {
            _goHomeAlertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Drone request for go home, are you sure go home now ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"GoHome Now", nil];
            [_goHomeAlertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        DJIPhantomMainController* phantomMC = (DJIPhantomMainController*)_drone.mainController;
        [phantomMC ignoreGoHomeReuqest:^(DJIError *error) {
            if (error.errorCode != ERR_Successed) {
                [self showErrorMessage:[NSString stringWithFormat:@"Ignore GoHome Failed:(%@)", error.errorDescription]];
            }
            else
            {
                [self showSuccessed:@"Ignore Go Home Successed"];
            }
        }];
    }
    else
    {
        DJIPhantomMainController* phantomMC = (DJIPhantomMainController*)_drone.mainController;
        [phantomMC confirmGoHomeReuqest:^(DJIError *error) {
            if (error.errorCode != ERR_Successed) {
                [self showErrorMessage:[NSString stringWithFormat:@"Confirm GoHome Failed:(%@)", error.errorDescription]];
            }
            else
            {
                [self showSuccessed:@"Confirm Go Home Successed"];
            }
        }];
    }
    
    _goHomeAlertView = nil;
}

#pragma mark - DJIDroneDelegate

-(void) droneOnConnectionStatusChanged:(DJIConnectionStatus)status
{
    switch (status) {
        case ConnectionStartConnect:
            
            break;
        case ConnectionSuccessed:
        {
            _connectionStatusLabel.text = @"Connected";
            break;
        }
        case ConnectionFailed:
        {
            _connectionStatusLabel.text = @"Connect Failed";
            break;
        }
        case ConnectionBroken:
        {
            _connectionStatusLabel.text = @"Disconnected";
            break;
        }
        default:
            break;
    }
}
@end
