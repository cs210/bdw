/*  
 *  IDService.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


typedef void (^IDServiceCallCompletionBlock)(NSError *error);

/*!
 @class IDService An abstract service base class.
 */
@interface IDService : NSObject

@end
