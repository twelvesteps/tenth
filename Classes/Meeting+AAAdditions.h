//
//  Meeting+AAAdditions.h
//  Steps
//
//  Created by Tom on 11/28/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "Meeting.h"

typedef NS_ENUM(NSInteger, AAMeetingProgramSymbolType) {
    AAMeetingProgramSymbolTypeCircleAroundTriangle,
    AAMeetingProgramSymbolTypeTriangleAroundCircle,
};

@interface Meeting (AAAdditions)

@property (nonatomic) BOOL openMeeting;

- (NSDate*)endDate;

- (NSString*)dayOfWeekString;
- (NSString*)startTimeString;
- (NSString*)endTimeString;

- (NSComparisonResult)compareStartTime:(Meeting*)otherMeeting;
- (NSComparisonResult)compareWeekday:(Meeting*)otherMeeting;
- (NSComparisonResult)compareTitle:(Meeting*)otherMeeting;
- (NSComparisonResult)compare:(Meeting*)otherMeeting;

@end
