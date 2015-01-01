//
//  AAMeetingTableViewCell.m
//  Steps
//
//  Created by Tom on 11/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserSettingsManager.h"

#import "AAMeetingTableViewCell.h"
#import "AAMeetingFellowshipIcon.h"

#import "Meeting+AAAdditions.h"


@interface AAMeetingTableViewCell()

@property (nonatomic, weak) AAMeetingLabel* meetingLabel;

@end

@implementation AAMeetingTableViewCell

#pragma mark - Properties

- (void)setMeeting:(Meeting *)meeting
{
    _meeting = meeting;
    
    [self updateViews];
}

- (void)updateViews
{
    self.startDateLabel.text = [self.meeting startTimeString];
    self.endDateLabel.text = [self.meeting endTimeString];
    self.titleLabel.text = self.meeting.title;
    self.addressLabel.text = self.meeting.location;
    self.fellowshipIcon.format = [self.meeting.formats anyObject];
    self.fellowshipIcon.program = self.meeting.program;
    self.fellowshipIcon.isOpen = self.meeting.openMeeting;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

@end
