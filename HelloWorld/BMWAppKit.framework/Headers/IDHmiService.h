/*  
 *  IDHmiService.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


#import "IDService.h"
#import "IDPropertyTypes.h"

@class IDVariantData;
@class IDVariantMap;
@class IDTableData;
@class IDVersionInfo;

/*!
 @class IDHmiService
 @abstract This class offers direct access to low-level API functions.
 @discussion Do not use this class unless you really know what you are doing! Please consider using the Widget API instead. This class offers methods to directly access actions, events, models and properties of RHMI applications.
 */
@interface IDHmiService : IDService


@property (strong, readonly) NSDictionary *hmiCapabilities;

/*!
 @method startWithHmiDescription:textDatabases:imageDatabases:error:
 @abstract Registers the hmi service with the HMI.
 @discussion Once physically connected ths method can be used to send an application's resources
 @param hmiDescription A binary blob of the application's hmi description XML file.
 @param textDatabases An array of binary data of all the zip files holding localized text strings.
 @param imageDatabases An array of binary data holding image resources for different vehicle brands.
 @param error If the call fails the reason will be stored in the error object.
 @return YES on success, NO otherwise.
 */
- (BOOL)startWithHmiDescription:(NSData *)hmiDescription textDatabases:(NSArray *)textDatabases imageDatabases:(NSArray *)imageDatabases error:(NSError **)error;

/*!
 @method addHandlerForHmiEvent:component:target:selector:
 @abstract Use this method to register callback selectors for HMI events with the HMI service.
 @discussion The given selector is called when a specific event occurs for the given component.
 @param eventId Specifies the type of events a target wants to receive callbacks for. For a list of possible values please refer to the @link //apple_ref/c/tdef/IDEventTypes/IDEventTypes @/link enum.
 @param componentId Identifier of the HMI component.
 @param target The object that defines the given selector.
 @param selector A selector that identifies the method to invoke.
 */
- (void)addHandlerForHmiEvent:(NSUInteger)eventId component:(NSUInteger)componentId target:(id)target selector:(SEL)selector;

/*!
 @method addHandlerForActionEvent:target:selector:
 @abstract Use this method to register callback selectors for remote actions with the HMI service.
 @discussion The given selector is called every time a remote action is triggered in the HMI. The callback method can take an @link //apple_ref/occ/cl/IDVariantMap @/link object as parameter. The given variant map is used to pass additional information (e.g. the index of a table row that was selected) to the target.
 @param actionId ID of the remote action which the callback should be registered for.
 @param target The object that defines the given selector.
 @param selector A selector that identifies the method to invoke.
 */
- (void)addHandlerForActionEvent:(NSUInteger)actionId target:(id)target selector:(SEL)selector;

/*!
 @method removeAllHmiEventHandlersForTarget:
 @abstract Use this method to deregister all callback selectors of the provided target from the hmi service.
 @param target The object for which all callbacks will be removed
 */
- (void)removeAllHmiEventHandlersForTarget:(id)target;

/*!
 @method removeHandlerForHmiEvent:component:target:selector:
 @abstract Use this method to deregister callback selectors from the hmi service.
 @param eventId Specifies the event type which a target wants to stop receiving callbacks for. For a list of possible values please refer to the @link //apple_ref/c/tdef/IDEventTypes/IDEventTypes @/link enum.
 @param componentId Identifier of the HMI component.
 @param target The object that defines the given selector.
 @param selector A selector that identifies the method to invoke.
 */
- (void)removeHandlerForHmiEvent:(NSUInteger)eventId component:(NSUInteger)componentId target:(id)target selector:(SEL)selector;

/*!
 @method removeAllActionEventHandlersForTarget:
 @abstract Use this method to deregister all callback selectors of the provided target from the hmi service.
 @param target The object for which all callbacks will be removed
 */
- (void)removeAllActionEventHandlersForTarget:(id)target;

/*!
 @method removeHandlerForActionEvent:target:selector:
 @abstract Use this method to deregister callbacks for remote actions from the HMI service.
 @param actionId ID of the remote action which the callback should be registered for.
 @param target The object that defines the given selector.
 @param selector A selector that identifies the method to invoke.
 */
- (void)removeHandlerForActionEvent:(NSUInteger)actionId target:(id)target selector:(SEL)selector;

/*!
 @method setDataModel:variantData:completionBlock:
 @abstract This method can be used to write data to HMI models.
 @discussion The method will accept all types of @link //apple_ref/occ/cl/IDVariantData @/link for every HMI model. But for the changes to appear correctly in the HMI the type of the given variant data needs to match the model type in the HMI description.
 @param modelId ID of the HMI model.
 @param data Represents the data that should be written to the model.
 @param completionBlock the block is called after the data was transmitted to the hmi, in case of an error the error parameter will be set
 */
- (void)setDataModel:(NSInteger)modelId variantData:(IDVariantData *)data completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method setListModel:tableData:completionBlock:
 @abstract This method can be used to write new data to a HMI list model.
 @discussion If the complete contents of a table needs to be updated you should use this method.
 @param modelId ID of the HMI list model.
 @param data The table data.
 @param completionBlock the block is called after the data was transmitted to the hmi, in case of an error the error parameter will be set
 */
- (void)setListModel:(NSInteger)modelId tableData:(IDTableData *)data completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method setListModel:tableData:fromRow:rows:fromColumn:columns:completionBlock:
 @abstract This method can be used to write new data to a HMI list model.
 @discussion Use this method if you want to update specific parts of a table.
 @param modelId ID of the HMI list model.
 @param data The table data.
 @param fromRow Index of the first row that should be updated.
 @param rows Number of rows that should be updated.
 @param fromColumn Index of the first column that should be update.
 @param columns Number of columns that should be updated.
 @param completionBlock the block is called after the data was transmitted to the hmi, in case of an error the error parameter will be set
 */
- (void)setListModel:(NSInteger)modelId tableData:(IDTableData *)data fromRow:(NSUInteger)fromRow rows:(NSUInteger)rows fromColumn:(NSUInteger)fromColumn columns:(NSUInteger)columns completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method setListModel:tableData:fromRow:rows:fromColumn:columns:totalRows:totalColumns:completionBlock:
 @abstract This method can be used to write new data to a HMI list model.
 @discussion Use this method if you want to update specific parts of a table.
 @param modelId ID of the HMI list model.
 @param data The table data.
 @param fromRow Index of the first row that should be updated.
 @param rows Number of rows that should be updated.
 @param fromColumn Index of the first column that should be update.
 @param columns Number of columns that should be updated.
 @param totalRows Total number of rows.
 @param totalColumns Total number of columns.
 @param completionBlock the block is called after the data was transmitted to the hmi, in case of an error the error parameter will be set 
 */
- (void)setListModel:(NSInteger)modelId tableData:(IDTableData *)data fromRow:(NSUInteger)fromRow rows:(NSUInteger)rows fromColumn:(NSUInteger)fromColumn columns:(NSUInteger)columns totalRows:(NSUInteger)totalRows totalColumns:(NSUInteger)totalColumns completionBlock:(IDServiceCallCompletionBlock)completionBlock;


/*!
 @method setProperty:forComponent:variantMap:completionBlock:
 @abstract This method can be used to change values of properties for HMI components.
 @param propertyId Specifies which property should be changed.
 @param componentId Specifies which HMI component should be updated.
 @param map A variant map containing the data this property should be set to for the key @link IDParameterValue @/link
 @param completionBlock the block is called after the data was transmitted to the hmi, in case of an error the error parameter will be set  
 */
- (void)setProperty:(IDPropertyType)propertyId forComponent:(NSInteger)componentId variantMap:(IDVariantMap *)map completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method setComponent:visible:completionBlock:
 @abstract Changes the value of the visible property for a given HMI component.
 @param componentId ID of the HMI component.
 @param visible Set to YES if the component should be visible or to NO if the component shall be hidden.
 @param completionBlock the block is called after the data was transmitted to the hmi, in case of an error the error parameter will be set
 */
- (void)setComponent:(NSInteger)componentId visible:(BOOL)visible completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method triggerHmiEvent:completionBlock:
 @abstract Triggers an event defined in the HMI description.
 @param eventId ID of the event to be triggered.
 @param completionBlock the block is called after the data was transmitted to the hmi, in case of an error the error parameter will be set
 */
- (void)triggerHmiEvent:(NSUInteger)eventId completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method triggerHmiEvent:parameterMap:completionBlock:
 @abstract Triggers an event defined in the HMI description and allows to add some data as parameters.
 @param eventId ID of the event to be triggered.
 @param params A variant map containing some parameters that should be passed along to the HMI.
 @param completionBlock the block is called after the data was transmitted to the hmi, in case of an error the error parameter will be set
 */
- (void)triggerHmiEvent:(NSUInteger)eventId parameterMap:(IDVariantMap *)params completionBlock:(IDServiceCallCompletionBlock)completionBlock;

@end
