//
//  NSDate+AAAdditions.h
//  Steps
//
//  Created by Tom on 5/12/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AAAdditions)

+ (NSDate*)dateForStartOfToday;
+ (NSDate*)dateForEndOfToday;
+ (BOOL)dateIsSameDayAsToday:(NSDate*)date;

+ (NSDate*)oneHour;

// info:        
// returns:     An integer representing the date's weekday.
// discussion:  Weekdays begin at 1 in the NSCalendar framework. Remember to adjust accordingly when accessing
//              arrays using weekday indices.
- (NSInteger)weekday;

// info:
- (NSDate*)timeOfDay;
- (NSDate*)nearestHalfHour;

+ (NSDate*)stepsReferenceDate;

+ (NSDate*)dateByCombiningWeekday:(NSInteger)weekday andStartTime:(NSDate*)startTime;
@end
