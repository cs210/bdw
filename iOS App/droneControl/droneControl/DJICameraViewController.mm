//
//  DJICamerViewController.m
//  TestApp
//
//  Created by Ares on 14-9-11.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "AerialViewController.h"
#import "TransparentTouchView.h"

@implementation DJICameraViewController

-(void) publicViewWillAppearMethod:(BOOL) animated
{
    [self viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _switch_to_usb = false;
    
    _droneHelper = [DJIDroneHelper sharedHelper];
    _camera = _droneHelper.drone.camera;
    _camera.delegate = self;
    
    //Start video data decode thread
    [[VideoPreviewer instance] start];

    _fetchingMedias = NO;
  
    _droneHelper.drone.gimbal.delegate = self;
    
    [_droneHelper onOpenButtonClicked];
    
    
    [self performSelector:@selector(onGimbalAttitudeScrollDown) withObject:nil afterDelay:1];
    [self performSelector:@selector(gimball_reset) withObject:nil afterDelay:5];
  
    self.view.userInteractionEnabled = NO;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(goToMap)
     forControlEvents:UIControlEventTouchUpInside];
    double height = 40.0;
    double width = 300.0;
    double x = self.view.frame.origin.x + 20.0;
    double y = self.view.frame.origin.y + 50.0;

    button.titleLabel.font = [UIFont systemFontOfSize:30];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [ button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    button.frame = CGRectMake(x,y,width,height);
    [button setTitle:@" Map View " forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:46.00/255.0f green:155.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];

    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Tap an open parking space!";
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:30]];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.layer.cornerRadius = 10;
    label.frame = CGRectMake(self.view.frame.size.width * 1.7, 40.0, 400.0, 60.0);
    [self.view addSubview:label];
}

-(void) goToMap{
    AerialViewController * aerialController;
    for (UIView* next = [self.view superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[AerialViewController class]])
        {
            aerialController = (AerialViewController *)nextResponder;
        }
        [aerialController showMap];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // [_drone connectToDrone];
    [_camera startCameraSystemStateUpdates];
    [[VideoPreviewer instance] setView:self.videoPreviewView];
    
    //gimbal
    [self onGimbalAttitudeScrollDown];
    
    //Show location of the car
    [self showCarLocation];
}

-(void) showCarLocation
{
    CLLocation * carLocation = [[LocationManager sharedManager] getUserLocation];
    CLLocationCoordinate2D carCoordinate = carLocation.coordinate;
    
    // Basically here take the car location, transform it into a pixel value on screen (hopefully)
    CLLocationCoordinate2D droneLocation = [[DJIDroneHelper sharedHelper ] getDroneGPS];
    
    // Take the long GPS location of the car, and compute a delta long from the Drone GPS
    float deltaLong = carCoordinate.longitude - droneLocation.longitude;
    float deltaLat = carCoordinate.latitude - droneLocation.latitude;
    
    // Divide the long/lat's by the drone altitude
    deltaLat = deltaLat / [_droneHelper getDroneHeight];
    deltaLong = deltaLong / [_droneHelper getDroneHeight];
    
    // Rotate by -Yaw
    float yaw = [_droneHelper getDroneYaw];
    yaw = -yaw;
    
    //float newLong = deltaLong * cos(yaw) - deltaLat * sin(yaw); // now x is something different than original vector x
    //float newLat = deltaLat * sin(yaw) + deltaLong * cos(yaw);
    
    //Now that we have offsets, we need to rotate according to the yaw of the drone
    
    /*CLLocationCoordinate2D carImageLocation = droneLocation;
    carImageLocation.latitude = droneLocation.latitude + (180/3.1415926)*(newLat/6378137.0);
    carImageLocation.longitude = droneLocation.longitude +  (180/3.1415926)*(newLong/6378137.0)/cos(droneGPS.latitude);*/
    
}

-(void) displayImage
{
    DJIMedia* media = [_mediasList lastObject];
    NSLog(@"%lu", (unsigned long)[_mediasList count]);
    if (media) {
        NSLog(@"GOT MEDIA :::::: ");
        __block long long totalDownload = 0;
        long long fileSize = _media.fileSize;
        NSMutableData* mediaData = [[NSMutableData alloc] init];
        [media fetchMediaData:^(NSData *data, BOOL *stop, NSError *error) {
            if (*stop) {
                if (error) {
                    NSLog(@"MEDIA ERROR ::::::: fetchMediaDataError:%@", error);
                }
            }
            else
            {
                if (data && data.length > 0)
                {
                    [mediaData appendData:data];
                    totalDownload += data.length;
                    int progress = (int)(totalDownload*100 / fileSize);
                    NSLog(@"MEDIA ::::::: Progress : %d", progress);
                }
            }
        }];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_camera stopCameraSystemStateUpdates];
    [[VideoPreviewer instance] setView:nil];
    
    [_droneHelper.drone.camera stopCameraSystemStateUpdates];

}

-(void) updateMedias
{
    _switch_to_usb = true;
    NSLog(@"Start Fetch Medias");
}

-(void) pull_image
{
    [_droneHelper.drone.camera fetchMediaListWithResultBlock:^(NSArray *mediaList, NSError *error) {
        if (mediaList)
        {
            _mediasList = mediaList;
            NSLog(@"MediaDirs: %@", _mediasList);
        }
        else
        {
            NSLog(@"NO MEDIALIST");
        }
        
        _fetchingMedias = NO;
    }];

    [self performSelector:@selector(displayImage) withObject:nil afterDelay:3];
    [self performSelector:@selector(switch_back_to_camera) withObject:nil afterDelay:5];
}

-(void) switch_back_to_camera
{
    _switch_to_usb = false;
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
    
    [_droneHelper.drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
        if (error.errorCode == ERR_Successed)
        {
            
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
    DJIGimbalAttitude attitude = _droneHelper.drone.gimbal.gimbalAttitude;
    NSLog(@"Gimbal Atti Pitch:%d, Roll:%d, Yaw:%d", attitude.pitch, attitude.roll, attitude.yaw);
}

-(void) gimball_reset
{
    DJIGimbalRotation pitch = {YES, 150, RelativeAngle, RotationBackward};
    DJIGimbalRotation roll = {NO, 0, RelativeAngle, RotationBackward};
    DJIGimbalRotation yaw = {YES, 0, RelativeAngle, RotationBackward};
    
    pitch.angle = 0;
    roll.angle = 0;
    yaw.angle = 0;

    [_droneHelper.drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
        if (error.errorCode == ERR_Successed)
        {
        }
        else
        {
            NSLog(@"Setting GimbalAttitude Failed");
        }
    }];
}

-(IBAction) onGimbalScrollDownTouchDown:(id)sender
{

}

-(IBAction) onGimbalScrollDownTouchUp:(id)sender
{
  [_droneHelper.drone.gimbal stopGimbalAttitudeUpdates];
}

-(void) onGimbalAttitudeScrollUp
{
    DJIGimbalRotation pitch = {YES, 150, RelativeAngle, RotationForward};
    DJIGimbalRotation roll = {NO, 0, RelativeAngle, RotationForward};
    DJIGimbalRotation yaw = {YES, 0, RelativeAngle, RotationForward};
    while (_gimbalAttitudeUpdateFlag) {
        [_droneHelper.drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
            if (error.errorCode == ERR_Successed)
            {
                
            }
        }];
        usleep(40000);
    }
    // stop rotation.
    pitch.angle = 0;
    roll.angle = 0;
    yaw.angle = 0;
    [_droneHelper.drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
    }];
}

-(void) onGimbalAttitudeYawRotationBackward
{
    DJIGimbalRotation pitch = {YES, 0, RelativeAngle, RotationBackward};
    DJIGimbalRotation roll = {NO, 0, RelativeAngle, RotationBackward};
    DJIGimbalRotation yaw = {YES, 16, RelativeAngle, RotationBackward};
    while (_gimbalAttitudeUpdateFlag)
    {
        [_droneHelper.drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error)
        {
            if (error.errorCode == ERR_Successed)
            {
                
            }
        }];
        usleep(40000);
    }
    // stop rotation.
    pitch.angle = 0;
    roll.angle = 0;
    yaw.angle = 0;
    [_droneHelper.drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
    }];
}

-(void) onGimbalAttitudeYawRotationForward
{
    DJIGimbalRotation pitch = {YES, 0, RelativeAngle, RotationForward};
    DJIGimbalRotation roll = {NO, 0, RelativeAngle, RotationForward};
    DJIGimbalRotation yaw = {YES, 16, RelativeAngle, RotationForward};
    while (_gimbalAttitudeUpdateFlag) {
        [_droneHelper.drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
            if (error.errorCode == ERR_Successed)
            {
                
            }
        }];
        usleep(40000);
    }
    // stop rotation.
    pitch.angle = 0;
    roll.angle = 0;
    yaw.angle = 0;
    [_droneHelper.drone.gimbal setGimbalPitch:pitch Roll:roll Yaw:yaw withResult:^(DJIError *error) {
    }];
}

#pragma mark - DJIGimbalDelegate

-(void) gimbalController:(DJIGimbal*)controller didGimbalError:(DJIGimbalError)error
{
    if (error == GimbalClamped)
    {
        NSLog(@"Gimbal Clamped");
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Gimbal Clamped" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    if (error == GimbalErrorNone)
    {
        NSLog(@"Gimbal Error None");
        
    }
    if (error == GimbalMotorAbnormal)
    {
        NSLog(@"Gimbal Motor Abnormal");
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Gimbal Motor Abnormal" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

//Camera Button

-(IBAction) onTakePhotoButtonClicked:(id)sender
{
    [_camera startTakePhoto:CameraSingleCapture withResult:^(DJIError *error) {
        if (error.errorCode != ERR_Successed) {
            NSLog(@"Take Photo Error : %@", error.errorDescription);
        }
    }];
    
    [self performSelector:@selector(updateMedias) withObject:nil afterDelay:2];
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
    if (_switch_to_usb) {
        NSLog(@":::::::: USB MODE ::::::::");
        if (!systemState.isUSBMode) {
            NSLog(@"Set USB Mode");
            [_droneHelper.drone.camera setCamerMode:CameraUSBMode withResultBlock:^(DJIError *error)
            {
                if (error.errorCode == ERR_Successed)
                {
                    NSLog(@"Set USB Mode Successed");
                    [self performSelector:@selector(pull_image) withObject:nil afterDelay:3];
                }
            }];
        }
        if (!systemState.isSDCardExist)
        {
            NSLog(@"SD Card Not Insert");
            return;
        }
        if (systemState.isConnectedToPC)
        {
            NSLog(@"USB Connected To PC");
            return;
        }
    }
    else
    {
        if (!systemState.isTimeSynced)
        {
            [_camera syncTime:nil];
        }
        
        if (systemState.isUSBMode)
        {
            [_camera setCamerMode:CameraCameraMode withResultBlock:Nil];
        }
    }
}

@end
