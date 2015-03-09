/*  
 *  IDTableLocation.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2014 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>


@interface IDTableLocation : NSObject <NSCopying>

/*!
 @method initWithRow:col:
 @abstract Initalize a table location object with a given row and column.
 @discussion This is the designated initializer.
 @param row the row in the table
 @param col the column in the table
 @return a table location
 */
- (instancetype)initWithRow:(int)row col:(int)col;

/*!
 @method locationWithRow:col:
 @abstract Create a table location object with a given row and column.
 @param row the row in the table
 @param col the column in the table
 @return a table location
 */
+ (instancetype)locationWithRow:(int)row col:(int)col;

@property int row;
@property int col;

@end
