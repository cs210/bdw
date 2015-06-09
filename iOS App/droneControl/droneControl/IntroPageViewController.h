//
//  IntroPageViewController.h
//  droneControl
//
//  Created by Ellen Sebastian on 5/7/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroPageViewController : UIViewController

/*!
 @class IntroPageViewController
 @abstract Start page of ConnectedDrone app, with a "find parking" button and speech detection.
 @discussion The AerialViewController displays a GoogleMapsViewController in the
 upper-left quadrant of the screen, and a live video feed from the drone in the rest of the screen.
 The user is prompted to touch a parking space. When the user touches the drone video feed,
 the touch location is translated into a GPS coordinate. The user is asked for a confirmation,
 and the app provides directions to the selected spot either by transitioning to the Google Maps app (if available)
 or highlighting the route on the existing GoogleMapsView.
 */

-(void) addTitle;

-(void) addParkingButton;

-(void) addDronePicture;

- (void)viewDidLoad;

-(void) findParkingClicked;


// SpeechDelegate stuff
-(NSArray * ) listOfWordsToDetect;
-(void) didReceiveWord: (NSString *) word;

@end