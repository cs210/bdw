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

/*!
 @class DJICameraViewController
 @abstract Live video feed view from drone.
 @discussion The DJICameraViewController connects to the drone using a DJIDroneHelper
 and creates a view that displays a live video feed from the drone's camera. 
 It also provides utilities for saving images taken through the app.
 */


@interface DJICameraViewController : UIViewController<DJICameraDelegate,  DJIGimbalDelegate>
/*!
 * @brief IBOutlet to the view which will display the live video feed.
 */
@property(nonatomic, retain) IBOutlet UIView* videoPreviewView;

/*!
 * @brief True if the gimbal is in the process of changing orientation.
 */
@property BOOL gimbalAttitudeUpdateFlag;
@property BOOL switch_to_usb;

/*!
 * @brief DJIDroneHelper to connect to the drone, fetch images and set gimbal orientation.
 */
@property DJIDroneHelper *droneHelper;

/*!
 * @brief Pointer to the drone's camera, used to take and fetch still photos.
 */
@property DJICamera* camera;

//media
/*!
 * @brief Last media fetched from the camera.
 */
@property DJIMedia* media;

/*!
 * @brief List of all medias fetched from the camera.
 */
@property NSArray* mediasList;

/*!
 * @brief True if we should fetch media from the camera.
 */
@property BOOL fetchingMedias;


/*!
 * @discussion Public method to call [self viewWillAppear]
 * @param animated: passed to [self viewWillAppear]
 */
- (void)publicViewWillAppearMethod:(BOOL) animated;

/*!
 * @discussion IBAction triggered when the Take Photo button is clicked. 
 * Triggers a photo to be taken and saved in mediasList.
 * @param sender: IBElement that was clicked
 */
-(IBAction) onTakePhotoButtonClicked:(id)sender;

-(IBAction) onGimbalScrollDownTouchDown:(id)sender;

-(IBAction) onGimbalScrollDownTouchUp:(id)sender;

@end
