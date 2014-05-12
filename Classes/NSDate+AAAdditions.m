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

+ (NSDate*)dateForTodayWithHour:(NSUInteger)hour Minute:(NSUInteger)minute Second:(NSUInteger)second
{
    NSCalendar* calender = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dateComponents = [calender components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];

    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = second;
    
    return [calender dateFromComponents:dateComponents];
}

@end
