/*  
 *  IDCdsService.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


#import "IDService.h"


@class IDVersionInfo;

/*!
 @class IDCdsService
 @abstract This service class provides the communication layer to the car data server.
 @discussion To be able to use the car data service an IDApplication must state that it requires access to the service in its manifest.
    If access to the car data service is granted this class can be used to retrieve information from the service.
    For all available properties (refer to @link //apple_ref/doc/header/CDSPropertyDefines.h @/link) there are in general two ways of retrieving their current value: binding to the property for retrieving updates for all changes of the properties value and getting the current value once.
 @updated 2012-05-24
 */
@interface IDCdsService : IDService

/*!
 @property versionInfo
 @abstract The version of the car data server built in the car the device is connected to.
 */
@property (strong, readonly) IDVersionInfo *versionInfo;

/*!
 @method bindProperty:target:selector:completionBlock:
 @abstract Bind to the value of a car data server property.
 @discussion Repetitive binding to the same property will result in an override of the previous bind. There may only exist one binding for a property at any time.
 @param propertyName name of the car data server property which should become bound
 @param target the target object to receive the callback
 @param selector the selector to be called when the property changed
 @param completionBlock The completion handler is executed after after a response from the hmi was received or an error has occured. If the call was successful the error parameter will be nil.
 */
- (void)bindProperty:(NSString *)propertyName target:(id)target selector:(SEL)selector completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method bindProperty:interval:target:selector:completionBlock:
 @abstract Bind to the value of a car data server property.
 @discussion Repetitive binding to the same property will result in an override of the previous bind. There may only exist one binding for a property at any time.
 @param propertyName name of the car data server property which should become bound
 @param interval te minimum data update time interval in seconds
 @param target the target object to receive the callback
 @param selector the selector to be called when the property changed
 @param completionBlock The completion handler is executed after after a response from the hmi was received or an error has occured. If the call was successful the error parameter will be nil.
 */
- (void)bindProperty:(NSString *)propertyName interval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method unbindProperty:target:selector:completionBlock:
 @abstract Unbind from the value of a car data server property.
 @discussion Unbinding from previously unbound properties will result in a no-op.
 @param propertyName name of the car data server property which should become unbound
 @param completionBlock The completion handler is executed after after a response from the hmi was received or an error has occured. If the call was successful the error parameter will be nil.
 */
- (void)unbindProperty:(NSString *)propertyName completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method asyncGetProperty:requestIdentifier:target:selector:completionBlock:
 @abstract Asynchronously fetch the value of a car data server property.
 @param propertyName name of the car data server property which should get fetched
 @param target the target object to receive the callback
 @param selector the selector to be called when the property got fetched
 @param completionBlock The completion handler is executed after after a response from the hmi was received or an error has occured. If the call was successful the error parameter will be nil.
 */
- (void)asyncGetProperty:(NSString *)propertyName target:(id)target selector:(SEL)selector completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method asyncGetProperty:requestIdentifier:target:selector:completionBlock:
 @abstract Asynchronously fetch the value of a car data server property.
 @param propertyName name of the car data server property which should get fetched
 @param identifier An identifier to map an incoming update to this one-off update
 @param target the target object to receive the callback
 @param selector the selector to be called when the property got fetched
 @param completionHandler The completion handler is executed after after a response from the hmi was received or an error has occured. If the call was successful the error parameter will be nil.
 */
- (void)asyncGetProperty:(NSString *)propertyName requestIdentifier:(NSString *)identifier target:(id)target selector:(SEL)selector completionBlock:(IDServiceCallCompletionBlock)completionBlock;


@end
