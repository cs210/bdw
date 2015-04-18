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

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [self onGimbalAttitudeScrollDown];
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

    //gimbal
//    [_drone connectToDrone];
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

//    while (TRUE) {
//        [_drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
//            if (error.errorCode == ERR_Successed) {
//                
//            }
//        }];
//        usleep(40000);
//    }
    
    // stop rotation.
    
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


///

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
