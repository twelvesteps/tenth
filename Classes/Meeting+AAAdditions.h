//
//  Meeting+AAAdditions.h
//  Steps
//
//  Created by Tom on 11/28/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "Meeting.h"

typedef NS_ENUM(NSInteger, AAMeetingFormat) {
    AAMeetingFormatLiterature = 0,
    AAMeetingFormatDiscussion = 1,
    AAMeetingFormatSpeaker = 2,
    AAMeetingFormatBeginner = 3,
    AAMeetingFormatStepStudy = 4,
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
