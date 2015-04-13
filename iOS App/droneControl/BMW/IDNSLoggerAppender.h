#import <UIKit/UIKit.h>
#import <BMWAppKit/IDLogger.h>


@interface IDNSLoggerAppender : NSObject <IDLogAppender>

- (id)initWithBonjourHostName:(NSString *)bonjourHostName;

/*!
 @method maximumLogLevel
 @abstract The maximum log level of a ns logger log appender instance. Only messages up to this log level will get sent to the ns logger.
 @discussion If this value exceeds the maximum log level of the default IDLogger instance it will become overruled by that one. Default value is IDLogLevelAll.
 */
@property (assign) IDLogLevel maximumLogLevel;
@property (copy) NSString *bonjourHostName;

@end
