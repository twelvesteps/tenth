//
//  AAMeetingTableViewCell.m
//  Steps
//
//  Created by Tom on 11/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserSettingsManager.h"

#import "AAMeetingTableViewCell.h"
#import "Meeting+AAAdditions.h"
#import "AAMeetingFellowshipIcon.h"

@implementation AAMeetingTableViewCell

#pragma mark - Properties

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    self.addressLabel.text = self.meeting.location;
    self.fellowshipIcon.openMeeting = self.meeting.openMeeting;
    self.fellowshipIcon.fellowshipNameLabel.text = @"AA";
    self.fellowshipIcon.color = [[AAUserSettingsManager sharedManager] colorForMeetingFormat:self.meeting.meetingFormat];
}

@end
