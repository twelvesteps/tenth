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

@interface AAMeetingTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *formatCircleViewWidth;
@property (weak, nonatomic) IBOutlet UIView *formatCircleView;


@end

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
    self.fellowshipIcon.format = self.meeting.meetingFormat;
    self.fellowshipIcon.program = self.meeting.meetingProgram;
    self.fellowshipIcon.isOpen = self.meeting.openMeeting;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    if (self.meeting.meetingFormat == AAMeetingFormatUnspecified) {
        self.formatCircleViewWidth.constant = 0.0f;
    } else {
        self.formatCircleViewWidth.constant = 32.0f;
    }
}


#pragma mark - Drawing

#define CIRCLE_RADIUS   5.0f

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.meeting.meetingFormat != AAMeetingFormatUnspecified) {
        [self drawCircle];
    }
}

- (void)drawCircle
{
    CGRect formatViewFrame = self.formatCircleView.frame;
    
    CGFloat originX = formatViewFrame.origin.x + (formatViewFrame.size.width - 2 * CIRCLE_RADIUS) / 2.0f;
    CGFloat originY = formatViewFrame.origin.y + (formatViewFrame.size.height - 2 * CIRCLE_RADIUS) / 2.0f;
    
    CGRect circleRect = CGRectMake(originX, originY, 2 * CIRCLE_RADIUS, 2 * CIRCLE_RADIUS);
    
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [[[AAUserSettingsManager sharedManager] colorForMeetingFormat:self.meeting.meetingFormat] setFill];
    [circlePath fill];
}

@end
