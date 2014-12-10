//
//  Meeting+AAAdditions.h
//  Steps
//
//  Created by Tom on 11/28/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "Meeting.h"

typedef NS_ENUM(NSInteger, AAMeetingFormat) {
    AAMeetingFormatLiterature,
    AAMeetingFormatDiscussion,
    AAMeetingFormatSpeaker,
    AAMeetingFormatBeginner,
    AAMeetingFormatStepStudy,
};

@interface Meeting (AAAdditions)

@property (nonatomic) AAMeetingFormat meetingFormat;
@property (nonatomic) BOOL openMeeting;

- (NSString*)meetingFormatString;

- (NSDate*)endDate;

- (NSString*)dayOfWeekString;
- (NSString*)startTimeString;
- (NSString*)endTimeString;

- (NSComparisonResult)compareStartTime:(Meeting*)otherMeeting;
- (NSComparisonResult)compareWeekday:(Meeting*)otherMeeting;
- (NSComparisonResult)compareTitle:(Meeting*)otherMeeting;
- (NSComparisonResult)compare:(Meeting*)otherMeeting;

@end
