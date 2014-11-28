//
//  Meeting+AAAdditions.m
//  Steps
//
//  Created by Tom on 11/28/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "Meeting+AAAdditions.h"

@implementation Meeting (AAAdditions)

- (NSDate*)endDate
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* durationComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.duration];
    
    return [calendar dateByAddingComponents:durationComponents toDate:self.startDate options:0];
}

- (NSString*)dayOfWeekString
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dayOfWeekDateComponents = [calendar components:(NSCalendarUnitWeekday) fromDate:self.startDate];
    
    return [calendar weekdaySymbols][dayOfWeekDateComponents.weekday - 1];
}

- (NSString*)startTimeString
{
    return [self timeStringFromDate:self.startDate];
}

- (NSString*)endTimeString
{
    return [self timeStringFromDate:[self endDate]];
}

- (NSString*)timeStringFromDate:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* timeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute)
                                                        fromDate:date];
    NSDate* time = [calendar dateFromComponents:timeComponents];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"j:mm" options:0 locale:[NSLocale autoupdatingCurrentLocale]];
    
    return [dateFormatter stringFromDate:time];
}

@end
