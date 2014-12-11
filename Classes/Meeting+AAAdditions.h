//
//  Meeting+AAAdditions.h
//  Steps
//
//  Created by Tom on 11/28/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "Meeting.h"

#define MEETING_FORMAT_COUNT    6
typedef NS_ENUM(NSInteger, AAMeetingFormat) {
    AAMeetingFormatUnspecified = 0,
    AAMeetingFormatLiterature = 1,
    AAMeetingFormatDiscussion = 2,
    AAMeetingFormatSpeaker = 3,
    AAMeetingFormatBeginner = 4,
    AAMeetingFormatStepStudy = 5,
};

typedef NS_ENUM(NSInteger, AAMeetingProgram) {
    AAMeetingProgramAA,
    AAMeetingProgramNA,
    AAMeetingProgramAlAnon,
    AAMeetingProgramAlateen,
};

@interface Meeting (AAAdditions)

@property (nonatomic) AAMeetingFormat meetingFormat;
@property (nonatomic) AAMeetingProgram meetingProgram;
@property (nonatomic) BOOL openMeeting;

+ (NSString*)plistKeyForMeetingFormat:(AAMeetingFormat)format;
+ (NSString*)stringForMeetingFormat:(AAMeetingFormat)format;
+ (NSString*)stringForProgram:(AAMeetingProgram)program;

- (NSString*)meetingFormatString;
- (NSString*)programName;

- (NSDate*)endDate;

- (NSString*)dayOfWeekString;
- (NSString*)startTimeString;
- (NSString*)endTimeString;

- (NSComparisonResult)compareStartTime:(Meeting*)otherMeeting;
- (NSComparisonResult)compareWeekday:(Meeting*)otherMeeting;
- (NSComparisonResult)compareTitle:(Meeting*)otherMeeting;
- (NSComparisonResult)compare:(Meeting*)otherMeeting;

@end
