
//
//  SpeechController.h
//  droneControl
//
//  Created by Michael Weingert on 2015-03-11.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenEars/OEEventsObserver.h>

@protocol SpeechDelegate

/*!
 * @discussion Return a list of words we want to listen for
 * @return NSArray The list of words we want to listen for
 */
-(NSArray * ) listOfWordsToDetect;

/*!
 * @discussion Protocol function that gets called when a word is identified
 * @param word The word that was identified
 */
-(void) didReceiveWord: (NSString *) word;

@end

@interface SpeechController : NSObject < OEEventsObserverDelegate >

/*!
 * @discussion Init the speech controller with a listener delegate
 * @param delegate The delegate that will receive speech events
 * @return The SpeechController object
 */
-(instancetype) initWithDelegate: (id<SpeechDelegate>)delegate;

/*!
 * @discussion Function to initialize the speech handler
 */
-(void) setupSpeechHandler;

/*!
 * @discussion Function to start the speech handler listening
 */
-(void) startListening;

/*!
 * @discussion Function to stop the speech handler listening
 */
-(void) stopListening;

@end
