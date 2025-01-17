/*  
 *  IDWidget.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDFlushProtocol.h"


@class IDModel;

/*!
 This class is the superclass for every HMI widget supported by the Widget API.
 */
@interface IDWidget : NSObject <IDFlushProtocol>

/*!
 @discussion The designated initializer.
 */
- (instancetype)initWithWidgetId:(NSInteger)widgetId model:(IDModel *)model;

/*!
 * Sets the widget to visible
 * (not KVO compliant).
 */
@property (nonatomic) BOOL visible;

/*!
* Sets the widget to enabled
 * (not KVO compliant).
 */
@property (nonatomic) BOOL enabled;

/*!
 * Sets the widget to selectable
 * (not KVO compliant).
 */
@property (nonatomic) BOOL selectable;

/*!
 * Sets the HMI focus to the component represented by the IDWidget object.
 */
- (void)focus;

@end
