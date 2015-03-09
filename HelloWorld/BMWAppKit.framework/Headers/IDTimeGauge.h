/*  
 *  IDTimeGauge.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDGauge.h"

@class IDTimeGauge;

/*!
 @protocol IDTimeGaugeDelegate
 @abstract This class implements the behavior of HMI time gauges in the Widget API.
 */
@protocol IDTimeGaugeDelegate <NSObject>

@optional

/*!
 @method gauge:didEndEditingTime:
 @abstract Called when the user clicks on the gauge to finish updating the value.
 @param gauge The gauge which was clicked.
 @param date The new value.
 */
- (void)gauge:(IDTimeGauge *)gauge didEndEditingTime:(NSDate *)date;

/*!
 @method gauge:didChangeTime:
 @abstract Called when the user changes a gauge's value. Not called when gauge value is programmatically set via the value property.
 @param gauge The gauge which the user changed.
 @param date The new value after the gauge has updated.
 */
- (void)gauge:(IDTimeGauge *)gauge didChangeTime:(NSDate *)date;

@end

/*!
 @class IDTimeGauge
 @abstract Delegate object for handling gauge update & change events must implement IDTimeGaugeDelegate protocol.
 @discussion Everytime the time value of the gauge is updated, following method of the delegate object will be triggered [self.delegate gauge:self didEndEditingTime:self.date]. When a new time value is set to the gauge, following method of the delegate object will be triggered [self.delegate gauge:self didChangeTime:self.date].
 */
@interface IDTimeGauge : IDGauge

/*!
 @property delegate
 @abstract The time gauge delegate.
 */
@property (nonatomic, weak) id<IDTimeGaugeDelegate> delegate;

/*!
 @property time
 @abstract time property used to store/retreive the value of the gauge in NSDate datatype.
 @discussion Only hour and minute of the date components are considered in the setter. Setting the time property to nil will implicitly set it to the current date. This property is not KVO compliant.
 */
@property (nonatomic, strong) NSDate *time;

@end
