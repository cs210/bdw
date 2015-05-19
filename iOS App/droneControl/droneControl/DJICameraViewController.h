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

@interface DJICameraViewController : UIViewController<DJICameraDelegate,  DJIGimbalDelegate>
{
    DJICamera* _camera;
    
    //media
    DJIMedia* _media;
    NSArray* _mediasList;
    BOOL _fetchingMedias;
}

@property(nonatomic, retain) IBOutlet UIView* videoPreviewView;
@property (weak, nonatomic) IBOutlet UIImageView *lastImage;

-(IBAction) onTakePhotoButtonClicked:(id)sender;

-(IBAction) onGimbalScrollDownTouchDown:(id)sender;

-(IBAction) onGimbalScrollDownTouchUp:(id)sender;

@end