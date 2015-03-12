/*  
 *  IDToolbarButton.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDButton.h"


@class IDModel;

/*!
 @class IDToolbarButton
 @abstract Represents a remote HMI toolbar button
 @discussion Represents a toolbar button with a tooltip. I.e. a button which can be used on the toolbar of the view. When focussed in the HMI the tooltip of this button is shown. So by updating the tooltipText property you can change the tooltip used as a propmt when the button gets focussed. And by updating the text property you can modify the text which is used to display the currently selected value.
 */
@interface IDToolbarButton : IDButton

/*!
 @method initWithWidgetId:model:tooltipModel:imageModel:targetModel:actionId:focusId:
 @discussion This is the designated initializer.
 */
- (instancetype)initWithWidgetId:(NSInteger)widgetId model:(IDModel *)model tooltipModel:(IDModel *)tooltipModel imageModel:(IDModel *)imageModel targetModel:(IDModel *)targetModel actionId:(NSInteger)actionId focusId:(NSInteger)focusId;

/*!
 @property tooltipText Set the tooltip text of a toolbar button.
 @discussion Assigning nil to this property clears the string from the button. This property is not KVO compliant.
 */
@property (nonatomic, copy) NSString *tooltipText;

/*!
 @property tooltipTextId Set the text ID for a toolbar button's tooltip text.
 @discussion This property is not KVO compliant.
 */
@property (nonatomic, assign) NSInteger tooltipTextId;

@end
