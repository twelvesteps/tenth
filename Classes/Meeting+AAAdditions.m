//
//  Meeting+AAAdditions.m
//  Steps
//
//  Created by Tom on 11/28/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "Meeting+AAAdditions.h"
#import "NSDate+AAAdditions.h"
#import "AAUserDataManager.h"

@implementation Meeting (AAAdditions)

#pragma mark - Properties

- (BOOL)openMeeting
{
    return [self.isOpen boolValue];
}

- (void)setOpenMeeting:(BOOL)openMeeting
{
    self.isOpen = @(openMeeting);
}


- (NSDate*)endDate
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* durationComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.duration];
    
    return [calendar dateByAddingComponents:durationComponents toDate:self.startDate options:0];
}


#pragma mark - Creating Strings

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


#pragma mark - Compare

- (NSComparisonResult)compare:(Meeting*)otherMeeting
{
    NSComparisonResult weekdayResult = [self compareWeekday:otherMeeting];
    if (weekdayResult != NSOrderedSame) {
        return weekdayResult;
    } else {
        NSComparisonResult startTimeResult = [self compareStartTime:otherMeeting];
        if (startTimeResult != NSOrderedSame) {
            return startTimeResult;
        } else {
            NSComparisonResult titleResult = [self compareTitle:otherMeeting];
            return titleResult;
        }
    }
}

- (NSComparisonResult)compareWeekday:(Meeting *)otherMeeting
{
    if (!otherMeeting) {
        return NSOrderedDescending;
    }
    
    if (!self.startDate) {
        if (!otherMeeting.startDate) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }
    
    NSInteger weekday = [self.startDate weekday];
    NSInteger otherWeekday = [otherMeeting.startDate weekday];
    
    if (weekday < otherWeekday) {
        return NSOrderedAscending;
    } else if (weekday > otherWeekday) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)compareStartTime:(Meeting *)otherMeeting
{
    if (!otherMeeting) {
        return NSOrderedDescending;
    }
    
    if (!self.startDate) {
        if (!otherMeeting.startDate) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }
    
    NSDate* startTime = [self.startDate timeOfDay];
    NSDate* otherStartTime = [otherMeeting.startDate timeOfDay];
    
    return [startTime compare:otherStartTime];
}

- (NSComparisonResult)compareTitle:(Meeting *)otherMeeting
{
    if (!otherMeeting) {
        return NSOrderedDescending;
    }
    
    if (!self.title) {
        if (!otherMeeting.title) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }
    
    return [self.title compare:otherMeeting.title];
}

@end
