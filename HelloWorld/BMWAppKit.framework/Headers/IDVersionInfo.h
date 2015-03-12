/*  
 *  IDVersionInfo.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @class IDVersionInfo
 @abstract IDVersionInfo represents version information
 */
@interface IDVersionInfo : NSObject

/*!
 @property major
 @abstract The major number of the version.
 */
@property (assign, readonly) NSUInteger major;

/*!
 @property minor
 @abstract The minor number of the version.
 */
@property (assign, readonly) NSUInteger minor;

/*!
 @property revision
 @abstract The revision number of the version.
 */
@property (assign, readonly) NSUInteger revision;

/*!
 @method versionInfoWithString:
 @abstract Returns a version info from the string.
 @param versionString The version information (minor, major, revision) in the string should be separated by ".".
 @return Version info object for string.
 */
+ (IDVersionInfo *)versionInfoWithString:(NSString *)versionString;

/*!
 @method versionInfoWithMajor:minor:revision:
 @abstract Creates an instance of IDVersionInfo with to given release numbers
 @param major Major release number
 @param minor Minor release number
 @param revision Revision number
 @return instance of IDVersionInfo
 */
+ (IDVersionInfo *)versionInfoWithMajor:(NSUInteger)major minor:(NSUInteger)minor revision:(NSUInteger)revision;

/*!
 @method initWithMajor:minor:revision:
 @abstract Creates an instance of IDVersionInfo with to given release numbers
 @param major Major release number
 @param minor Minor release number
 @param revision Revision number
 @return instance of IDVersionInfo
 */
- (id)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor revision:(NSUInteger)revision;

/*!
 @method stringValue
 @abstract Returns a string representing the version in the form "<major>.<minor>.<revision>".
 @return String representing the version in the form "<major>.<minor>.<revision>".
 */
- (NSString *)stringValue;

/*!
 @method isEqualToVersion:
 @abstract Compare two instances id IDVersionInfo
 @return Returns true when this version is equal to the other version.
 */
- (BOOL)isEqualToVersion:(IDVersionInfo *)otherVersion;

/*!
 @method compare:
 @abstract Returns a NSComparisonResult object indicating whether the receiver comes before or after the argument.
 @param otherVersion Instance of IDVersionInfo to compare to
 @return NSComparisonResult used to indicate how the operands are ordered, from the receiver to the argument (that is, left to right in code). NSOrderedAscending = The receiver is smaller than the argument; NSOrderedSame = Receiver and argument are equal in terms of ordering; NSOrderedDescending = The left operand is greater than the argument.
 */
- (NSComparisonResult)compare:(IDVersionInfo *)otherVersion;

@end
