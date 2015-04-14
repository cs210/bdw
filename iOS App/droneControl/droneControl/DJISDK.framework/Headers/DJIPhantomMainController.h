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
    MCSystemMode_Phantom,
    MCSystemMode_Naza,
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
 *  Set smart go home enable.
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
