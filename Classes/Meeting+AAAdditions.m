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

- (void)setMeetingFormat:(AAMeetingFormat)format
{
    self.format = @(format);
}

- (AAMeetingFormat)meetingFormat
{
    return [self.format integerValue];
}

- (void)setMeetingProgram:(AAMeetingProgram)meetingProgram
{
    self.program = @(meetingProgram);
}

- (AAMeetingProgram)meetingProgram
{
    return [self.program integerValue];
}

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

- (NSString*)meetingFormatString
{
    return [[Meeting meetingFormatStringMap] objectForKey:self.format];
}

+ (NSString*)plistKeyForMeetingFormat:(AAMeetingFormat)format
{
    return [[Meeting meetingFormatKeyMap] objectForKey:@(format)];
}

+ (NSString*)stringForMeetingFormat:(AAMeetingFormat)format
{
    return [[Meeting meetingFormatStringMap] objectForKey:@(format)];
}

+ (NSDictionary*)meetingFormatKeyMap
{
    static NSDictionary* meetingFormatStringMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        meetingFormatStringMap = @{@(AAMeetingFormatUnspecified): @"Unspecified",
                                   @(AAMeetingFormatBeginner)   : @"Beginnger",
                                   @(AAMeetingFormatDiscussion) : @"Discussion",
                                   @(AAMeetingFormatLiterature) : @"Literature",
                                   @(AAMeetingFormatSpeaker)    : @"Speaker",
                                   @(AAMeetingFormatStepStudy)  : @"Step Study"};
    });
    assert(meetingFormatStringMap.count == MEETING_FORMAT_COUNT);
    return meetingFormatStringMap;
}

+ (NSDictionary*)meetingFormatStringMap
{
    static NSDictionary* meetingFormatStringMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        meetingFormatStringMap = @{@(AAMeetingFormatUnspecified): NSLocalizedString(@"", @""),
                                   @(AAMeetingFormatBeginner)   : NSLocalizedString(@"Beginner", @"AA meeting specifically for beginners"),
                                   @(AAMeetingFormatDiscussion) : NSLocalizedString(@"Discussion", @"AA meeting focused on member discussion"),
                                   @(AAMeetingFormatLiterature) : NSLocalizedString(@"Literature", @"AA meeting focused on reading or discussing literature"),
                                   @(AAMeetingFormatSpeaker)    : NSLocalizedString(@"Speaker", @"AA meeting with a speaker or speaker's"),
                                   @(AAMeetingFormatStepStudy)  : NSLocalizedString(@"Step Study", @"AA meeting where a step or steps are discussed")};
    });
    assert(meetingFormatStringMap.count == MEETING_FORMAT_COUNT);
    return meetingFormatStringMap;
}

- (NSString*)programName
{
    return [[Meeting programNameMap] objectForKey:self.program];
}

+ (NSString*)stringForProgram:(AAMeetingProgram)program
{
    return [[Meeting programNameMap] objectForKey:@(program)];
}

+ (NSDictionary*)programNameMap
{
    static NSDictionary* programNameMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        programNameMap = @{@(AAMeetingProgramAA)        : NSLocalizedString(@"AA", @"Alcoholics Anonymous"),
                           @(AAMeetingProgramNA)        : NSLocalizedString(@"NA", @"Narcotics Anonymous"),
                           @(AAMeetingProgramAlAnon)    : NSLocalizedString(@"Al-Anon", @"Al-Anon"),
                           @(AAMeetingProgramAlateen)   : NSLocalizedString(@"Alateen", @"Aalateen")};
                           
    });
    
    return programNameMap;
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
