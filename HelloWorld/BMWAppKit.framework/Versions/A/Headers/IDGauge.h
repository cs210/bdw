/*  
 *  IDGauge.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDWidget.h"


@class IDModel;

/*!
 @class IDGauge
 */
@interface IDGauge : IDWidget

/*!
 @method initWithWidgetId:model:textModel:actionId:changeActionId:
 @discussion
    This is the designated initializer.
 */
- (instancetype)initWithWidgetId:(NSInteger)widgetId model:(IDModel *)model textModel:(IDModel *)textModel actionId:(NSInteger)actionId changeActionId:(NSInteger)changeActionId;

/*!
 @property width
    Use this property to set the width of a gauge
 @discussion
    Adjusting the width works only for gauges whose model type is "Progress". This property is not KVO compliant.
 */
@property (nonatomic, assign) NSInteger width;

/*!
 @property position
    Use this property to adjust the position of a gauge's top left corner.
 @discussion
    This property is not KVO compliant.
 */
@property (nonatomic, assign) CGPoint position;

/*!
 @property text
 @abstract Set the Text of a checkbox to a string value.
 @discussion Assigning nil to this property clears the string from the checkbox.
 Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
 associated to this checkbox. This property is meant to write a text string to the model and will only work if the
 corresponding model was declared as a data model (i.e. 'model string').
 (not KVO compliant)
 */
@property (nonatomic, copy) NSString *text;

/*!
 @property textId
 @abstract Set the Text of a checkbox to a text resource.
 @discussion  Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
 associated to this checkbox. This property is meant to write the ID of a text resource to the model and will only work if
 the corresponding model was declared as a text id model (i.e. 'id model string').
 (not KVO compliant)
 */
@property (nonatomic, assign) NSInteger textId;

@end
