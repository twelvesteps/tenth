//
//  NSDate+AAAdditions.h
//  Steps
//
//  Created by Tom on 5/12/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  Provides convenience methods for common date and time calculations performed
 *  by the Steps application.
 */
@interface NSDate (AAAdditions)

/**-----------------------------------------------------------------------------
 *  @name Alter Date Time Components
 *------------------------------------------------------------------------------
 */

/**
 *  Creates a date object for 12:00AM with the same day as the day it was
 *  called.
 *
 *  @return A new date object for the day it was called at 12:00AM.
 */
+ (NSDate*)dateForStartOfToday;

/**
 *  Creates a date object for 11:59PM with the same day as the day it was
 *  called.
 *
 *  @return A new date object for the day it was called at 11:59PM.
 */
+ (NSDate*)dateForEndOfToday;

/**
 *  A date object with its time set to one hour, 0 minutes, and 0 seconds. The
 *  day of this date is unspecified.
 *
 *  @return A date object with a time value of one hour.
 */
+ (NSDate*)oneHour;

/**
 *  Returns a date with the same day as the receiver but its time components are
 *  set to the nearest half hour relative to the receiver.
 *  If the receiver's minutes component is [0,14], minutes are set to 0
 *  If the receiver's minutes component is [15,45], minutes are set to 30
 *  If the receiver's minutes component is [46,59], minutes are set to 0 and the
 *  hour component is incremented by 1.
 *
 *  @return A date with the same day as the receiver and its hour, minute, and
 *  seconds rounded to the nearest half hour of the receiver.
 */
- (NSDate*)nearestHalfHour;

/**
 *  Combines the day value of one date with the time value of another
 *
 *  @param day  The date with the resultant day
 *  @param time The date with the resultant time
 *
 *  @return A new date object combining the day and time of the parameters
 */
+ (NSDate*)dateByCombiningDayOfDate:(NSDate*)day withTimeOfDate:(NSDate*)time;


/**-----------------------------------------------------------------------------
 *  @name Read/Alter Weekday
 *------------------------------------------------------------------------------
 */

/**
 *  Returns the weekday value for the date
 *
 *  @return An integer representing the date's weekday.
 */
- (NSInteger)weekday;

/**
 *  Returns a new date object with the given weekday value. The returned date
 *  value will occur within the same week as the date parameter. If the weekday
 *  matches date's weekday this method returns a copy of the date
 *
 *  @param date    The date to use as a baseline for altering the date
 *  @param weekday The integer representation of the weekday. If the value of
 *  weekday is not within the range [1, 7] the created date will have the same
 *  value as the original date.
 *
 *  @return A new date object similar to the given date but with the given 
 *          weekday.
 */
+ (NSDate*)dateByConvertingDate:(NSDate*)date toWeekday:(NSInteger)weekday;


@end
