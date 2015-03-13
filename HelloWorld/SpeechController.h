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

-(NSArray * ) listOfWordsToDetect;
-(void) didReceiveWord: (NSString *) word;

@end

@interface SpeechController : NSObject < OEEventsObserverDelegate >

-(instancetype) initWithDelegate: (id<SpeechDelegate>)delegate;

-(void) setupSpeechHandler;

-(void) startListening;

-(void) stopListening;

@end
