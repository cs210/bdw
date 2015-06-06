//
//  DJISDKMainController.h
//  DJISDK
//
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DJISDK/DJIMainController.h>

typedef NS_ENUM(NSInteger, DJIMCSystemMode)
{
    MCSystemMode_Phantom,   //Phantom mode
    MCSystemMode_Naza,      //NAZA mode
    MCSystemMode_Unknown
};

@interface DJIPhantomMainController : DJIMainController

/**
 *  Get main controller's system mode.
 *
 *  @param block  Remote execute result
 */
-(void) getMCSystemMode:(void(^)(DJIMCSystemMode mode, DJIError* error))block;

/**
 *  Set smart go home enable. If drone is set as smart go home enable, the drone will automaticly go home while it's need. or the drone will send a request for go home at DJIMCSmartGoHome
 *
 *  @param isEnable Enable for smart go home
 *  @param block  Remote execute result
 */
-(void) setSmartGoHomeEnable:(BOOL)isEnable withResult:(DJIExecuteResultBlock)block;

/**
 *  Get smart go home enable.
 *
 *  @param block  Remote execute result
 */
-(void) getSmartGoHomeEnable:(void(^)(BOOL isEnable, DJIError* error))block;

/**
 *  Confirm go home request. use to confirm go home request while the DJIMCSmartGoHome's droneRequestGoHome is set.
 *
 *  @param block  Remote execute result
 */
-(void) confirmGoHomeReuqest:(DJIExecuteResultBlock)block;

/**
 *  Ignore go home request. use to ingore go home request while the DJIMCSmartGoHome's droneRequestGoHome is set.
 *
 *  @param block  Remote execute result
 */
-(void) ignoreGoHomeReuqest:(DJIExecuteResultBlock)block;

@end
