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
#import "AAMeetingLabel.h"

#import "Meeting+AAAdditions.h"


@interface AAMeetingTableViewCell()

@property (nonatomic, weak) AAMeetingLabel* meetingLabel;

@end

@implementation AAMeetingTableViewCell

#pragma mark - Properties

- (void)awakeFromNib
{
    self.titleLabel.leftCircle = NO;
}

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
    self.titleLabel.format = self.meeting.meetingFormat;
    self.addressLabel.text = self.meeting.location;
    self.fellowshipIcon.format = self.meeting.meetingFormat;
    self.fellowshipIcon.program = self.meeting.meetingProgram;
    self.fellowshipIcon.isOpen = self.meeting.openMeeting;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

@end
