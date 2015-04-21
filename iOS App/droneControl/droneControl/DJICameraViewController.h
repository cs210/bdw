//
//  DJICamerViewController.h
//  TestApp
//
//  Created by Ares on 14-9-11.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DJISDK/DJIDrone.h>
#import <DJISDK/DJICamera.h>
#import <DJISDK/DJIGimbal.h>
#import <DJISDK/DJISDK.h> //DJIDroneDelegate,

@interface DJICamerViewController : UIViewController<DJICameraDelegate,  DJIGimbalDelegate>
{
    DJIDrone* _drone;
    DJICamera* _camera;
}

@property(nonatomic, retain) IBOutlet UIView* videoPreviewView;

-(IBAction) onTakePhotoButtonClicked:(id)sender;

-(IBAction) onGimbalScrollDownTouchDown:(id)sender;

-(IBAction) onGimbalScrollDownTouchUp:(id)sender;

@end
