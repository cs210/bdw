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
#import "DJIDroneHelper.h"
#import "DJICameraViewController.h"
#import "VideoPreviewer.h"
#import "CoordinatePointTuple.h"
#import "LocationManager.h"

@interface DJICameraViewController : UIViewController<DJICameraDelegate,  DJIGimbalDelegate>


- (void)publicViewWillAppearMethod:(BOOL) animated;
@property(nonatomic, retain) IBOutlet UIView* videoPreviewView;
@property (weak, nonatomic) IBOutlet UIImageView *lastImage;
@property BOOL gimbalAttitudeUpdateFlag;
@property BOOL switch_to_usb;
@property DJIDroneHelper *droneHelper;
@property NSArray * coordinatePointTuples;
@property UIView * dummyTouchView;
@property DJICamera* camera;
//media
@property DJIMedia* media;
@property NSArray* mediasList;
@property BOOL fetchingMedias;



-(IBAction) onTakePhotoButtonClicked:(id)sender;

-(IBAction) onGimbalScrollDownTouchDown:(id)sender;

-(IBAction) onGimbalScrollDownTouchUp:(id)sender;

@end