//
//  NSDateFormatter+AAAdditions.h
//  Steps
//
//  Created by Tom on 1/9/15.
//  Copyright (c) 2015 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Provides convenience methods on an NSDateFormatter object for predefined
 *  styles used by the Steps iOS application.
 */
@interface NSDateFormatter (AAAdditions)

/**
 *  Returns a formatted string displaying the weekday, month, day, and year of
 *  the given date in long format according to the device's current locale
 *  settings.
 *
 *  @param date The date to be formatted into a string
 *
 *  @return A formatted, localized string representing the given date
 */
- (NSString*)stepsLongDateStringFromDate:(NSDate*)date;

/**
 *  Returns a formatted string displaying the month and day of the given date in
 *  a short format according to the device's current locale settings.
 *  If the year of the date differs from the current year then the year will
 *  also be included in the string.
 *
 *  @param date The date to be formatted into a string
 *
 *  @return A formatted, localized string representing the given date
 */
- (NSString*)stepsShortDateStringFromDate:(NSDate*)date;

/**
 *  Returns a string using the hour and minutes value of the given date. 
 *  The user's current locale and calendar settings will be used to determine
 *  the proper formatting of the string.
 *  The template for the string is 'j:mm'.
 *
 *  @param date The date containing the time to be displayed
 *
 *  @return A localized, formatted string with the date's hour and minutes field
 */
- (NSString*)stepsTimeStringFromDate:(NSDate*)date;

/**
 *  Returns the long string for the given date's weekday value.
 *
 *  @param date The date with the weekday to be used
 *
 *  @return A localized string of the given date's weekday
 */
- (NSString*)stepsDayOfWeekStringFromDate:(NSDate*)date;


@end
