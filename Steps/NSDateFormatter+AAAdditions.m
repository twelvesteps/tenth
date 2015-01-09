//
//  NSDateFormatter+AAAdditions.m
//  Steps
//
//  Created by Tom on 1/9/15.
//  Copyright (c) 2015 spitzgoby LLC. All rights reserved.
//

#import "NSDateFormatter+AAAdditions.h"

@implementation NSDateFormatter (AAAdditions)

- (NSString*)stepsTimeStringFromDate:(NSDate*)date
{
    self.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"j:mm" options:0 locale:[NSLocale autoupdatingCurrentLocale]];
    return [self stringFromDate:date];
}

- (NSString*)dayOfWeekStringFromDate:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dayOfWeekDateComponents = [calendar components:(NSCalendarUnitWeekday) fromDate:date];
    
    return [calendar weekdaySymbols][dayOfWeekDateComponents.weekday - 1];
}

@end
