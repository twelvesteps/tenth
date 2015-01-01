//
//  NSDate+AAAdditions.m
//  Steps
//
//  Created by Tom on 5/12/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "NSDate+AAAdditions.h"

@implementation NSDate (AAAdditions)

+ (NSDate*)dateForStartOfToday
{
    return [self dateForTodayWithHour:0 Minute:0 Second:0];
}

+ (NSDate*)dateForEndOfToday
{
    return [self dateForTodayWithHour:23 Minute:59 Second:59];
}

+ (BOOL)dateIsSameDayAsToday:(NSDate *)date
{
    return ([date timeIntervalSinceDate:[NSDate dateForStartOfToday]] > 0 && [date timeIntervalSinceDate:[NSDate dateForEndOfToday]]);
}

+ (NSDate*)dateForTodayWithHour:(NSUInteger)hour Minute:(NSUInteger)minute Second:(NSUInteger)second
{
    NSCalendar* calender = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dateComponents = [calender components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];

    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = second;
    
    return [calender dateFromComponents:dateComponents];
}

+ (NSDate*)oneHour
{
    NSCalendar* calender = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    
    dateComponents.hour = 1;
    
    return [calender dateFromComponents:dateComponents];
}

- (NSInteger)weekday
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dateComponents = [calendar components:(NSCalendarUnitWeekday) fromDate:self];
    
    return dateComponents.weekday;
}

+ (NSDate*)stepsReferenceDate
{
    // December 12th, 2014 (a Sunday)
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    components.month = 12; // December 21st, 2014
    components.day = 21;
    components.year = 2014;
    
    NSDate* date = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:components];

    assert(date.weekday == 1);
    
    return date;
}

+ (NSDate*)dateByCombiningDayOfDate:(NSDate*)day withTimeOfDate:(NSDate*)time
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSDateComponents* dayComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:day];
    NSDateComponents* timeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:time];
    
    dayComponents.hour = timeComponents.hour;
    dayComponents.minute = timeComponents.minute;
    dayComponents.second = timeComponents.second;
    
    return [calendar dateFromComponents:dayComponents];
}

+ (NSDate*)dateByCombiningWeekday:(NSInteger)weekday andStartTime:(NSDate*)startTime
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dateComponents = [calendar components:(NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startTime];
    dateComponents.second = 0;
    NSInteger weekdayOffset = weekday - dateComponents.weekday;
    
    return [calendar dateByAddingUnit:NSCalendarUnitDay value:weekdayOffset toDate:startTime options:0];
}

- (NSDate*)timeOfDay
{
    NSCalendar* calender = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dateComponents = [calender components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    
    return [calender dateFromComponents:dateComponents];
}

- (NSDate*)nearestHalfHour
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dateComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    
    dateComponents.second = 0;
    if (dateComponents.minute > 45) {
        dateComponents.hour += 1;
    }
    
    if (abs((int)dateComponents.minute - 30) > 15) {
        dateComponents.minute = 0;
    } else {
        dateComponents.minute = 30;
    }
    
    return [calendar dateFromComponents:dateComponents];
}

@end
