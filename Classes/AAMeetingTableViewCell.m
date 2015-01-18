//
//  AAMeetingTableViewCell.m
//  Steps
//
//  Created by Tom on 11/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserSettingsManager.h"

#import "AAMeetingTableViewCell.h"
#import "AAMeetingProgramDecorationView.h"

#import "Location.h"

#import "NSDateFormatter+AAAdditions.h"

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
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    self.startDateLabel.text = [formatter stepsTimeStringFromDate:self.meeting.startDate];
    self.endDateLabel.text = [formatter stepsTimeStringFromDate:self.meeting.endDate];
    self.titleLabel.text = self.meeting.title;
    self.addressLabel.text = self.meeting.location.title;
    self.programDecorationView.program = self.meeting.program;
    self.programDecorationView.isOpen = self.meeting.isOpenValue;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

@end
