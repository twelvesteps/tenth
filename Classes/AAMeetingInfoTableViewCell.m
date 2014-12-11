//
//  AAMeetingInfoTableViewCell.m
//  Steps
//
//  Created by Tom on 11/27/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserSettingsManager.h"

#import "AAMeetingInfoTableViewCell.h"
#import "Meeting+AAAdditions.h"
#import "AAMeetingFellowshipIcon.h"

#import "UIFont+AAAdditions.h"
#import "UIColor+AAAdditions.h"

@interface AAMeetingInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *meetingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingChairpersonLabel;
@property (weak, nonatomic) IBOutlet UITextView *meetingDetailTextView;

@property (weak, nonatomic) IBOutlet AAMeetingFellowshipIcon *fellowshipIcon;

@end

@implementation AAMeetingInfoTableViewCell

#pragma mark - Lifecycle and Properties

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    self.topSeparator = YES;
    
    self.meetingDetailTextView.textContainer.lineFragmentPadding = 0.0f;
    self.meetingDetailTextView.textContainerInset = UIEdgeInsetsZero;
    
    self.meetingTitleLabel.font = [UIFont stepsHeaderFont];
    self.meetingLocationLabel.font = [UIFont stepsSubheaderFont];
    self.meetingChairpersonLabel.font = [UIFont stepsCaptionFont];
    self.meetingChairpersonLabel.textColor = [UIColor stepsBlueColor];
    self.meetingDetailTextView.font = [UIFont stepsBodyFont];
    self.meetingDetailTextView.selectable = NO;
}

- (void)setMeeting:(Meeting *)meeting
{
    _meeting = meeting;
    [self updateViews];
    [self setNeedsLayout];
}

#pragma mark - Update Views

- (void)updateViews
{
    self.meetingTitleLabel.text = self.meeting.title;
    self.meetingLocationLabel.text = self.meeting.location;
    self.meetingChairpersonLabel.text = (self.meeting.userIsChairPerson) ? NSLocalizedString(@"Chair Person", @"Leader of the AA meeting") : @"";
    self.meetingDetailTextView.text = [self detailText];
    self.fellowshipIcon.openMeeting = self.meeting.openMeeting;
    self.fellowshipIcon.fellowshipNameLabel.text = @"AA";
    self.fellowshipIcon.color = [[AAUserSettingsManager sharedManager] colorForMeetingFormat:self.meeting.meetingFormat];
}

- (NSString*)detailText
{
    NSString* detailText = [self.meeting dayOfWeekString];
    detailText = [detailText stringByAppendingFormat:@"\n%@ - %@", [self.meeting startTimeString], [self.meeting endTimeString]];
    
    NSString* typesString = [self meetingTypesString];
    if (typesString) {
        detailText = [detailText stringByAppendingFormat:@"\n%@", [self meetingTypesString]];
    }
    
    return detailText;
}

- (NSString*)meetingTypesString
{
    return nil;
}

#pragma mark - Layout

#define TOP_EDGE_PADDING        14.0f
#define BOTTOM_EDGE_PADDING     8.0f
#define LEADING_EDGE_PADDING    14.0f
#define TRAILING_EDGE_PADDING   8.0f

#define FELLOWSHIP_ICON_WIDTH   32.0f
#define FELLOWSHIP_ICON_HEIGHT  32.0f


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutTitleLabel];
    [self layoutLocationLabel];
    [self layoutChairpersonLabel];
    [self layoutDetailTextView];
    [self layoutFellowshipIcon];
}

- (void)layoutTitleLabel
{
    CGSize labelSize = [self sizeForLabel:self.meetingTitleLabel
                                     font:[UIFont stepsHeaderFont]
                             boundingSize:[self titleAndLocationLabelTextBoundingSize]];
    
    CGRect meetingTitleLabelFrame = CGRectMake(self.contentView.bounds.origin.x + LEADING_EDGE_PADDING,
                                               self.contentView.bounds.origin.y + TOP_EDGE_PADDING,
                                               labelSize.width,
                                               labelSize.height);
    
    self.meetingTitleLabel.frame = meetingTitleLabelFrame;
                
}

- (void)layoutLocationLabel
{
    CGSize labelSize = [self sizeForLabel:self.meetingLocationLabel
                                     font:[UIFont stepsSubheaderFont]
                             boundingSize:[self titleAndLocationLabelTextBoundingSize]];
    
    CGRect meetingLocationLabelFrame = CGRectMake(self.meetingTitleLabel.frame.origin.x,
                                                  CGRectGetMaxY(self.meetingTitleLabel.frame),
                                                  labelSize.width,
                                                  labelSize.height);
    
    self.meetingLocationLabel.frame = meetingLocationLabelFrame;
}

- (void)layoutChairpersonLabel
{
    CGSize labelSize = [self sizeForLabel:self.meetingChairpersonLabel
                                     font:[UIFont stepsCaptionFont]
                             boundingSize:[self textBoundingSize]];
    CGRect meetingChairpersonLabelFrame = CGRectMake(self.meetingTitleLabel.frame.origin.x,
                                                     CGRectGetMaxY(self.meetingLocationLabel.frame),
                                                     labelSize.width,
                                                     labelSize.height);
    
    self.meetingChairpersonLabel.frame = meetingChairpersonLabelFrame;
}

- (void)layoutDetailTextView
{
    CGRect meetingDetailTextViewFrame = CGRectMake(self.meetingTitleLabel.frame.origin.x,
                                                   CGRectGetMaxY(self.meetingChairpersonLabel.frame),
                                                   self.contentView.bounds.size.width - (LEADING_EDGE_PADDING + TRAILING_EDGE_PADDING),
                                                   [self heightForTextView:self.meetingDetailTextView font:[UIFont stepsBodyFont]]);
    
    self.meetingDetailTextView.frame = meetingDetailTextViewFrame;
}

- (void)layoutFellowshipIcon
{
    CGFloat iconOriginX = MAX(CGRectGetMaxX(self.meetingTitleLabel.frame), CGRectGetMaxX(self.meetingLocationLabel.frame)) + TRAILING_EDGE_PADDING;
    CGFloat iconOriginY = (self.meetingTitleLabel.frame.origin.y + CGRectGetMaxY(self.meetingLocationLabel.frame)) / 2.0f - FELLOWSHIP_ICON_HEIGHT / 2.0f;
    
    CGRect fellowshipIconFrame = CGRectMake(iconOriginX,
                                            iconOriginY,
                                            FELLOWSHIP_ICON_WIDTH,
                                            FELLOWSHIP_ICON_HEIGHT);
    
    self.fellowshipIcon.frame = fellowshipIconFrame;
}

- (CGSize)sizeForLabel:(UILabel*)label font:(UIFont*)font boundingSize:(CGSize)boundingSize
{
    CGSize size = [label.text boundingRectWithSize:boundingSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil].size;
    
    size.height = ceilf(size.height);
    size.width = ceilf(size.width);
    
    return size;
}

- (CGFloat)heightForTextView:(UITextView*)textView font:(UIFont*)font
{
    CGFloat height = [textView.text boundingRectWithSize:[self textBoundingSize]
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName : font}
                                                 context:nil].size.height;
    
    return ceilf(height);
}

- (CGSize)textBoundingSize
{
    CGSize boundingSize = CGSizeMake(self.contentView.bounds.size.width - (LEADING_EDGE_PADDING + TRAILING_EDGE_PADDING), CGFLOAT_MAX);
    return boundingSize;
}

- (CGSize)titleAndLocationLabelTextBoundingSize
{
    CGFloat trailingEdgeInset = 2 * TRAILING_EDGE_PADDING + FELLOWSHIP_ICON_WIDTH;
    CGSize boundingSize = CGSizeMake(self.contentView.bounds.size.width - (LEADING_EDGE_PADDING + trailingEdgeInset), CGFLOAT_MAX);
    return boundingSize;
}


#pragma mark - Class Methods

+ (CGFloat)heightForCell:(AAMeetingInfoTableViewCell*)cell
{
    CGFloat height = TOP_EDGE_PADDING + BOTTOM_EDGE_PADDING;
    
    height += [cell sizeForLabel:cell.meetingTitleLabel font:[UIFont stepsHeaderFont] boundingSize:[cell titleAndLocationLabelTextBoundingSize]].height;
    height += [cell sizeForLabel:cell.meetingLocationLabel font:[UIFont stepsSubheaderFont] boundingSize:[cell titleAndLocationLabelTextBoundingSize]].height;
    height += [cell sizeForLabel:cell.meetingChairpersonLabel font:[UIFont stepsCaptionFont] boundingSize:[cell textBoundingSize]].height;
    height += [cell heightForTextView:cell.meetingDetailTextView font:[UIFont stepsBodyFont]];
    
    return height;
}

@end
