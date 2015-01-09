//
//  NSDateFormatter+AAAdditions.h
//  Steps
//
//  Created by Tom on 1/9/15.
//  Copyright (c) 2015 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (AAAdditions)

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
- (NSString*)dayOfWeekStringFromDate:(NSDate*)date;


@end
