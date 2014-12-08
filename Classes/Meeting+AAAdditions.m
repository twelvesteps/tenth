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

#define OPEN_MEETING_TYPE   @"Open"
#define CLOSED_MEETING_TYPE @"Closed"

- (void)setOpenMeeting:(BOOL)openMeeting
{
    MeetingType* openType = [[AAUserDataManager sharedManager] getMeetingType:OPEN_MEETING_TYPE];
    MeetingType* closedType = [[AAUserDataManager sharedManager] getMeetingType:CLOSED_MEETING_TYPE];
    
    [self removeTypes:[NSSet setWithObjects:openType, closedType, nil]];
    
    if (openMeeting) {
        [self addTypesObject:openType];
    } else {
        [self addTypesObject:closedType];
    }
}

- (BOOL)openMeeting
{
    MeetingType* openType = [[AAUserDataManager sharedManager] getMeetingType:OPEN_MEETING_TYPE];
    return [self.types containsObject:openType];
}

- (NSDate*)endDate
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* durationComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.duration];
    
    return [calendar dateByAddingComponents:durationComponents toDate:self.startDate options:0];
}


#pragma mark - Creating String

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
