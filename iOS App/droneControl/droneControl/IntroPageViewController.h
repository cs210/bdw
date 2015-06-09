//
//  IntroPageViewController.h
//  droneControl
//
//  Created by Ellen Sebastian on 5/7/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SpeechController.h"
#import "DJICameraViewController.h"
#import "TransparentTouchView.h"
#import "AerialViewController.h"

@interface IntroPageViewController : UIViewController

/*!
 @class IntroPageViewController
 @abstract Start page of ConnectedDrone app, with a "find parking spot" button and speech detection.
 @discussion Displays an intro page with name and logo. When "Find Parking Spot" is clicked or the user says "find parking", 
 the app segues to AerialViewController.
 */

/** 
 * @discussion Adds a "ConnectedDrone" title to the view.
 */
-(void) addTitle;

/** 
 * @discussion Adds a "Find parking spot" button to the view, which leads to the AerialViewController when clicked.
 *
 */
-(void) addParkingButton;

/**
 * @discussion Adds a non-clickable drone graphic to the view.
 */

-(void) addDronePicture;

/**
 * @discussion Arranges UIElements in the view.
 */
-(void)viewDidLoad;

/**
 * @discussion Called when the "find parking spot" button is clicked; transitions to the AerialViewController.
 */
-(void) findParkingClicked;


/**
 * @discussion list of words that OpenEars speech detection should detect.
 * @return NSArray of words to detect: "Find parking", "yes", "cancel".
 */
-(NSArray * ) listOfWordsToDetect;

/**
 * @discussion Called when OpenEars detects a word from listOfWordsToDetect. 
 * If the word is "Find parking", transitions to AerialViewController.
 * @param word that was detected.
 */
-(void) didReceiveWord: (NSString *) word;


typedef enum
{
    kListening,
    kNotListening
} listeningStates;


@end