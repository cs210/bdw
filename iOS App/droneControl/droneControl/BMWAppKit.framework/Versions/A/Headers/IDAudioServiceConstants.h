/*  
 *  IDAudioServiceConstants.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


/*!
 @enum IDAudioState
 @abstract Defines possible states of the audio service.
 @constant IDAudioStateActivePlaying Used to indicate a playing audio channel (i.e. the application is now the active
 active audio source).
 @constant IDAudioStateActiveMuted Used to indicate a muted audio channel (i.e. the audio channel was muted by the user
 or by the audio master in the head unit).
 @constant IDAudioStateInactive Used to indicate an inactive audio channel.
 */
typedef enum  {
    IDAudioStateInvalid = 0,
    IDAudioStateActivePlaying,
    IDAudioStateActiveMuted,
    IDAudioStateInactive
} IDAudioState;

/*!
 @enum IDAudioButtonEvent
 @abstract Defines possible events for the skip buttons of the multimedia system.
 @constant IDAudioButtonEventSkipUp This event can be triggered by shortly pressing the up or next button.
 @constant IDAudioButtonEventSkipDown  This event can be triggered by shortly pressing the down or previous button.
 @constant IDAudioButtonEventSkipLongUp  This event can be triggered by long pressing the up or next button.
 @constant IDAudioButtonEventSkipLongDown This event can be triggered by long pressing the down or previous button.
 @constant IDAudioButtonEventSkipStop This event is triggered by releasing a button after a long press.
 */
typedef enum {
    IDAudioButtonEventInvalid = 0,
    IDAudioButtonEventSkipUp,
    IDAudioButtonEventSkipDown,
    IDAudioButtonEventSkipLongUp,
    IDAudioButtonEventSkipLongDown,
    IDAudioButtonEventSkipStop
} IDAudioButtonEvent;

/*!
 @enum IDAudioConnectionType
 @abstract The audio channels available on the head unit
 */
typedef enum {
    IDAudioConnectionTypeEntertainment = 0,
    IDAudioConnectionTypeInterrupt = 1,
    IDAudioConnectionTypeInvalid = 2
} IDAudioConnectionType;

/*!
 @enum IDAudioPlayerState
 @abstract The available states a audio player on the head unit can have
 */
typedef enum {
    IDAudioPlayerStatePlay,
    IDAudioPlayerStatePause,
    IDAudioPlayerStateStop,
    IDAudioPlayerStateInvalid
} IDAudioPlayerState;
