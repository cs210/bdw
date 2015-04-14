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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _drone = [[DJIDrone alloc] initWithType:DJIDrone_Phantom];
    _camera = _drone.camera;
    _camera.delegate = self;
    
    //Start video data decode thread
    [[VideoPreviewer instance] start];
    
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
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_camera stopCameraSystemStateUpdates];
    [_drone disconnectToDrone];
    [[VideoPreviewer instance] setView:nil];
}

-(BOOL) shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

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
