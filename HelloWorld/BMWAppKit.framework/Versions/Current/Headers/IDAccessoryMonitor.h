/*  
 *  IDAccessoryMonitor.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


@class IDVehicleInfo;
@class IDVersionInfo;

/*!
 @constant IDAccessoryDidAppearNotification
 @abstract Gets posted as soon as an A4A compatible accessory was detected.
 @discussion Communication with the accessory might not be possible yet or might never be possible. This notification should be used to stop receiving remote control events and reconfigure the AVAudioSession of the iOS device.
 */
extern NSString *const IDAccessoryDidAppearNotification;

/*!
 @constant IDAccessoryDidDisappearNotification
 @abstract Gets posted when the A4A compatible accessory is no longer available.
 @discussion This notification should be used to start receiving remote control events again and reconfigure the AVAudioSession of the iOS device.
 */
extern NSString *const IDAccessoryDidDisappearNotification;

/*!
 @constant IDAccessoryDidConnectNotification
 @abstract Gets posted when a supported external accessory was connected.
 @discussion After this notification was received communication with the accessory is possible.
 */
extern NSString *const IDAccessoryDidConnectNotification;

/*!
 @constant IDAccessoryDidDisconnectNotification
 @abstract Gets posted when a supported external accessory was disconnected.
 @discussion After this notification was received communication with the accessory is no longer possible. This doesn't imply that the accessory is phyically disconnected.
 */
extern NSString *const IDAccessoryDidDisconnectNotification;

/*!
 @constant IDAccessoryNetworkAccessDidChangeNotification
 @abstract Notification indicating network access by the accessory monitor (cellular or wifi).
 @discussion The notification is sent when the network access status of the monitor did change. Developers may use the notification to inform the user about network access. The userInfo dictionary of the notification contains a BOOL value whether the network is used by the monitor or not. The notification is posted on the main thread.
 */
extern NSString *const IDAccessoryNetworkAccessDidChangeNotification;
extern NSString *const IDAccessoryUsingNetworkKey;

/*!
 @constant IDA4AProtocolString
 @discussion The protocol string for A4A compatible hardware accessories.
 */
extern NSString *const IDA4AProtocolString;

/*!
 @class IDAccessoryMonitor
 @abstract This class is responsible for monitoring the availability of a BMWAppKit compatible accessory.
 @discussion The supported external accessory protocol string is: "com.bmw.a4a". The developer is responsible to add the protocol string to the Info.plist file and to register for local notification (external accessory). The class will send out notifications to inform about the connection status to the BMWAppKit compatible accessory. This class is not intended to be sublcassed.
 */
@interface IDAccessoryMonitor : NSObject

@property (strong, readonly) IDVehicleInfo *vehicleInfo; // not KVO compliant
@property (strong, readonly) IDVersionInfo *cdsVersion; // not KVO compliant
@property (strong, readonly) IDVersionInfo *etchVersion; // not KVO compliant

/*!
 @method init
 @abstract Returns a preconfigured instance of a4a accessory monitor.
 @discussion The monitor will be configured depending on its environment. Keep a strong reference to the returned instance as long as the accessory monitor is required.
 @return The accessory monitor instance.
 */
- (id)init;

/*!
 @method startMonitoring
 @abstract Method to start monitoring for BMWAppKit compatible accessories.
 @discussion Make sure to register the a4a protocol string and enable local notification handler prior to calling this method. The accessory monitor will not post a4a accessory related notifications before this method was called.
 */
- (void)startMonitoring;

/*!
 @method stopMonitoring
 @abstract Method to stop monitoring for BMWAppKit compatible accessorys.
 @discussion After this method was called the accessory monitor will no longer post a4a accessory related notification.
 */
- (void)stopMonitoring;

@end
