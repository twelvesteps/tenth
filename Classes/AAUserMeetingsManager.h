//
//  AAUserMeetingsManager.h
//  Steps
//
//  Created by Tom on 12/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserDataManager.h"
#import "Meeting+AAAdditions.h"
#import "MeetingFormat.h"
#import "MeetingProgram.h"

static const NSString* AADidDeleteMeetingFormatNotification = @"MeetingFormatDeleted";
static const NSString* AADidDeleteMeetingProgramNotification = @"MeetingProgramDeleted";

@interface AAUserMeetingsManager : AAUserDataManager

+ (instancetype)sharedManager;

- (Meeting*)createMeeting;

- (void)removeMeeting:(Meeting*)meeting;
- (void)removeMeetingFormat:(MeetingFormat*)format;
- (void)removeMeetingProgram:(MeetingProgram*)program;

- (NSArray*)fetchMeetings; // sorted by startDate
- (NSArray*)fetchMeetingFormats; // sorted by popularity
- (NSArray*)fetchMeetingPrograms; // sorted by popularity

- (MeetingFormat*)fetchMeetingFormatWithIdentifier:(NSString*)identifier;
- (MeetingProgram*)fetchMeetingProgramWithIdentifier:(NSString*)identifier;

- (MeetingFormat*)meetingFormatWithTitle:(NSString*)title;
- (MeetingProgram*)meetingProgramWithTitle:(NSString*)title;

- (BOOL)meetingFormatShouldChangeTitle:(MeetingFormat*)format;

@end
