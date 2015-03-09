/*  
 *  IDAudioService.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


#import "IDService.h"
#import "IDAudioServiceConstants.h"


@class IDAudioService;

#pragma mark - IDAudioServiceDelegate protocol

/*!
 @protocol IDAudioServiceDelegate
 @abstract Audio Service Delegate protocol.
 @discussion Implement this protocol if you would like to receive callbacks for state changes of the audio service and multimedia button events. It is vital for the audio system (audio source mixing) within the hmi that the iOS application using BMWAppKit respects the delegate calls. No playback before a channel is switched to active playing or after the channel was set to inactive.
 */
@protocol IDAudioServiceDelegate <NSObject>

@required
/*!
 @method audioService:entertainmentStateChanged:
 @abstract Inform the delegate that the state of the entertainment channel has changed.
 @discussion The delegate MUST always respect the IDAudioState passed in as second method argument.
 @param audioService the audio service
 @param newState the new audio state
 */
- (void)audioService:(IDAudioService *)audioService entertainmentStateChanged:(IDAudioState)newState;

/*!
 @method audioService:interruptStateChanged:
 @abstract Inform the delegate that the state of the interrupt channel has changed.
 @discussion The delegate MUST always respect the IDAudioState passed in as second method argument.
 @param audioService the audio service
 @param newState the new audio state
 */
- (void)audioService:(IDAudioService *)audioService interruptStateChanged:(IDAudioState)newState;

/*!
 @method audioService:multimediaButtonEvent:
 @abstract Inform the delegate that an multimedia button event was received from the remote hmi.
 @discussion Button events are generated when the driver of a vehicle uses a physical multimedia button in his vehicle.
 @param audioService the audio service
 @param button the button event
 */
- (void)audioService:(IDAudioService *)audioService multimediaButtonEvent:(IDAudioButtonEvent)buttonEvent;

@end

#pragma mark - IDAudioService

/*!
 @class IDAudioService
 @abstract Service class for audio related hmi functionality.
 @discussion The audio service is used to control audio channels within the head unit. An application using BMWAppKit is required to request a audio channel before it might start audio playback. Also the hmi needs to know if the application no longer requires the channel. The audio service supports entertainment and interrupt audio (different mixing behavior). Only one channel should be used at a time. Using both channels at the same time is not officially supported and might lead to unexpected behavior. For starting the playback of entertainment audio from an iOS device (e.g. a music or podcast player) an app would have to request an entertainment channel with -activateEntertainment and release the entertainment channel with deactivateEntertainment. For playing short audio sequences like notification sounds or navigation instructions an app can use activateInterrupt to interrupt the vehicle's current entertainment audio playback. After playing the audio sequence the application is supposed to close the interrupt channel by calling deactivateInterrupt. This will cause the vehicle's entertainment audio source to continue playback. The delegate of the audio service will receive callbacks whenever the state of an entertainment or interrupt channel changes. Furthermore the delegate will also receive callbacks whenever a skip button is pressed either on the steering wheel or in the vehicle's center stack.
 */
@interface IDAudioService : IDService

/*!
 @method activateEntertainment
 @abstract Method to activate the entertainment channel.
 @discussion This method should be called before an iOS application intends to play entertainment audio through the vehicle's audio system. The audio system delegate gets informed asynchronously about the entertainment channel's state. After the method returns the caller MUST NOT start playback immediately. Instead wait for the audio service delegate callback. If the delegate already has an interrupt channel it has to call deactivateInterrupt before, otherwise audioService:entertainmentStateChanged: might not get called.
 */
- (void)activateEntertainment;

/*!
 @method deactivateEntertainment
 @abstract Method to deactivate the entertainment channel.
 @discussion This method should be called when an iOS application wants to stop playing entertainment audio. The vehicle's audio master will fall back to the entertainment audio source that was active right before activateEntertainment was called. The caller should stop playback before calling this method. NEVER continue playback after this method was called.
 */
- (void)deactivateEntertainment;

/*!
 @method activateInterrupt
 @abstract Method to activate the interrupt channel.
 @discussion This method should be called before an iOS application intends to play interrupt audio sequences through the vehicle's audio system. The vehicle's audio master will fade the audio interruption over the currently playing entertainment audio source if it is one of the vehicle's native audio sources (e.g. radio, CD/Multimedia, ...). After the method returns the delegate MUST NOT start playback immediately. Instead wait for the audio service delegate callback. If the delegate already has an entertainment channel it has to call deactivateEntertainment before, otherwise audioService:interruptStateChanged: might not get called.
 */
- (void)activateInterrupt;

/*!
 @method deactivateInterrupt
 @abstract Method to deactivate the interrupt channel.
 @discussion The caller should stop playback before calling this method. NEVER continue playback after this method was called.
 */
- (void)deactivateInterrupt;

/*!
 @property delegate
 @abstract The Audio Service delegate is passed updates when changes to audio state occur.
 @discussion After setting the delegate, have it initially check the current state and react accordingly. Only audio state changes will be automatically passed to the delegate.
 */
@property (assign) id<IDAudioServiceDelegate> delegate;

/*!
 @property entertainmentAudioState
 @abstract Current entertainment audio state. Not KVO compliant.
 */
@property (readonly, nonatomic) IDAudioState entertainmentAudioState;

/*!
 @property interruptAudioState
 @abstract Current interrupt audio state. Not KVO compliant.
 */
@property (readonly, nonatomic) IDAudioState interruptAudioState;

@end
