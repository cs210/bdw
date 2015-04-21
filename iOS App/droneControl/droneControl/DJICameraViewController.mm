//
//  DJICamerViewController.m
//  TestApp
//
//  Created by Ares on 14-9-11.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "DJICameraViewController.h"
#import "VideoPreviewer.h"
#import <DJISDK/DJISDK.h>

@implementation DJICamerViewController

    BOOL _gimbalAttitudeUpdateFlag;
    BOOL doneLoading;

- (void)viewDidLoad
{
    [super viewDidLoad];
    doneLoading = false;
    // Do any additional setup after loading the view from its nib.
    
    _drone = [[DJIDrone alloc] initWithType:DJIDrone_Phantom];
    _camera = _drone.camera;
    _camera.delegate = self;
    
    //Start video data decode thread
    [[VideoPreviewer instance] start];

    //gimbal
//    _drone = [[DJIDrone alloc] initWithType:DJIDrone_Phantom];
//    _drone.delegate = self;
    
    _drone.gimbal.delegate = self;
//    [self onGimbalAttitudeScrollDown];
    doneLoading = true;
    [self performSelector:@selector(onGimbalAttitudeScrollDown) withObject:nil afterDelay:1];
    [self performSelector:@selector(gimball_reset) withObject:nil afterDelay:5];
}

-(void) dealloc
{
    [_drone destroy];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_drone connectToDrone];
    [_camera startCameraSystemStateUpdates];
    [[VideoPreviewer instance] setView:self.videoPreviewView];
//    [self onGimbalAttitudeScrollDown];
    //gimbal
//    [_drone connectToDrone];
    if (doneLoading) {
        NSLog(@"::::::::::::: DONE view did load");
        [self onGimbalAttitudeScrollDown];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_camera stopCameraSystemStateUpdates];
    [[VideoPreviewer instance] setView:nil];
    
    //gimabl
    [_drone disconnectToDrone];
    [_drone destroy];
}

- (IBAction)prepare_gimbal_button:(id)sender
{
    NSLog(@":::::::::: Gimbal prep");
    [self onGimbalAttitudeScrollDown];
}

- (IBAction)reset_gimbal_button:(id)sender
{
    NSLog(@":::::::::: Gimbal reset");
    [self gimball_reset];
}


-(BOOL) shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

-(void) onGimbalAttitudeScrollDown
{
    DJIGimbalRotation pitch = {YES, 150, RelativeAngle, RotationBackward};
    DJIGimbalRotation roll = {NO, 0, RelativeAngle, RotationBackward};
    DJIGimbalRotation yaw = {YES, 0, RelativeAngle, RotationBackward};
    
    pitch.angle = 300;
    roll.angle = 0;
    yaw.angle = 0;
    
    [_drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
        if (error.errorCode == ERR_Successed) {
            
        }
        else
        {
            NSLog(@"Set GimbalAttitude Failed");
        }
    }];
    [self readGimbalAttitude];
}

-(void) readGimbalAttitude
{
    DJIGimbalAttitude attitude = _drone.gimbal.gimbalAttitude;
    NSLog(@"Gimbal Atti Pitch:%d, Roll:%d, Yaw:%d", attitude.pitch, attitude.roll, attitude.yaw);
    
    //    while (true) {
    //
    //        [NSThread sleepForTimeInterval:0.2];
    //    }
}


-(void) gimball_reset
{
    DJIGimbalRotation pitch = {YES, 150, RelativeAngle, RotationBackward};
    DJIGimbalRotation roll = {NO, 0, RelativeAngle, RotationBackward};
    DJIGimbalRotation yaw = {YES, 0, RelativeAngle, RotationBackward};
    
    pitch.angle = 0;
    roll.angle = 0;
    yaw.angle = 0;

    [_drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
        if (error.errorCode == ERR_Successed)
        {
            
        }
        else
        {
            NSLog(@"Setting GimbalAttitude Failed");
        }
    }];
}

//-(IBAction) onGimbalScroollDownTouchDown:(id)sender
//{
//    _gimbalAttitudeUpdateFlag = YES;
//    [NSThread detachNewThreadSelector:@selector(onGimbalAttitudeScrollDown) toTarget:self withObject:nil];
//    NSOperationQueue* asyncQueue = [NSOperationQueue mainQueue];
//    asyncQueue.maxConcurrentOperationCount = 1;
//    [_drone.gimbal startGimbalAttitudeUpdateToQueue:asyncQueue withResultBlock:^(DJIGimbalAttitude attitude) {
////        NSString* attiString = [NSString stringWithFormat:@"Pitch = %d\nRoll = %d\nYaw = %d\n", attitude.pitch, attitude.roll, attitude.yaw];
////        self.attitudeLabel.text = attiString;
//    }];
//}
//
//-(IBAction) onGimbalScroollDownTouchUp:(id)sender
//{
//    _gimbalAttitudeUpdateFlag = NO;
//    [_drone.gimbal stopGimbalAttitudeUpdates];
//}

-(void) onGimbalAttitudeScrollUp
{
    DJIGimbalRotation pitch = {YES, 150, RelativeAngle, RotationForward};
    DJIGimbalRotation roll = {NO, 0, RelativeAngle, RotationForward};
    DJIGimbalRotation yaw = {YES, 0, RelativeAngle, RotationForward};
    while (_gimbalAttitudeUpdateFlag) {
        [_drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
            if (error.errorCode == ERR_Successed) {
                
            }
        }];
        usleep(40000);
    }
    // stop rotation.
    pitch.angle = 0;
    roll.angle = 0;
    yaw.angle = 0;
    [_drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
    }];
}

-(void) onGimbalAttitudeYawRotationBackward
{
    DJIGimbalRotation pitch = {YES, 0, RelativeAngle, RotationBackward};
    DJIGimbalRotation roll = {NO, 0, RelativeAngle, RotationBackward};
    DJIGimbalRotation yaw = {YES, 16, RelativeAngle, RotationBackward};
    while (_gimbalAttitudeUpdateFlag) {
        [_drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
            if (error.errorCode == ERR_Successed) {
                
            }
        }];
        usleep(40000);
    }
    // stop rotation.
    pitch.angle = 0;
    roll.angle = 0;
    yaw.angle = 0;
    [_drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
    }];
}

-(void) onGimbalAttitudeYawRotationForward
{
    DJIGimbalRotation pitch = {YES, 0, RelativeAngle, RotationForward};
    DJIGimbalRotation roll = {NO, 0, RelativeAngle, RotationForward};
    DJIGimbalRotation yaw = {YES, 16, RelativeAngle, RotationForward};
    while (_gimbalAttitudeUpdateFlag) {
        [_drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
            if (error.errorCode == ERR_Successed) {
                
            }
        }];
        usleep(40000);
    }
    // stop rotation.
    pitch.angle = 0;
    roll.angle = 0;
    yaw.angle = 0;
    [_drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
    }];
}

#pragma mark - DJIGimbalDelegate

-(void) gimbalController:(DJIGimbal*)controller didGimbalError:(DJIGimbalError)error
{
    if (error == GimbalClamped) {
        NSLog(@"Gimbal Clamped");
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Gimbal Clamped" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    if (error == GimbalErrorNone) {
        NSLog(@"Gimbal Error None");
        
    }
    if (error == GimbalMotorAbnormal) {
        NSLog(@"Gimbal Motor Abnormal");
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Gimbal Motor Abnormal" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

//#pragma mark - DJIDroneDelegate
//
//-(void) droneOnConnectionStatusChanged:(DJIConnectionStatus)status
//{
//    switch (status) {
//        case ConnectionStartConnect:
//        {
//            NSLog(@"Start Reconnect...");
//            break;
//        }
//        case ConnectionSuccessed:
//        {
//            NSLog(@"Connect Successed...");
//            _connectionStatusLabel.text = @"Connected";
//            break;
//        }
//        case ConnectionFailed:
//        {
//            NSLog(@"Connect Failed...");
//            _connectionStatusLabel.text = @"Connect Failed";
//            break;
//        }
//        case ConnectionBroken:
//        {
//            NSLog(@"Connect Broken...");
//            _connectionStatusLabel.text = @"Disconnected";
//            break;
//        }
//        default:
//            break;
//    }
//}



//Camera Button

-(IBAction) onTakePhotoButtonClicked:(id)sender
{
    [_camera startTakePhoto:CameraSingleCapture withResult:^(DJIError *error) {
        if (error.errorCode != ERR_Successed) {
            NSLog(@"Take Photo Error : %@", error.errorDescription);
        }
    }];
    NSLog(@"Photo button clicked");
}

#pragma mark - DJICameraDelegate

-(void) camera:(DJICamera*)camera didReceivedVideoData:(uint8_t*)videoBuffer length:(int)length
{
    uint8_t* pBuffer = (uint8_t*)malloc(length);
    memcpy(pBuffer, videoBuffer, length);
    [[VideoPreviewer instance].dataQueue push:pBuffer length:length];
}

-(void) camera:(DJICamera*)camera didUpdateSystemState:(DJICameraSystemState*)systemState
{
    if (!systemState.isTimeSynced) {
        [_camera syncTime:nil];
    }
    if (systemState.isUSBMode) {
        [_camera setCamerMode:CameraCameraMode withResultBlock:Nil];
    }
}

@end
