//
//  AAMeetingInfoTableViewCell.m
//  Steps
//
//  Created by Tom on 11/27/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingInfoTableViewCell.h"
#import "MeetingType.h"
#import "Meeting+AAAdditions.h"
#import "UIFont+AAAdditions.h"

@interface AAMeetingInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *meetingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingChairpersonLabel;
@property (weak, nonatomic) IBOutlet UITextView *meetingDetailTextView;


@end

@implementation AAMeetingInfoTableViewCell

#pragma mark - Lifecycle and Properties

- (void)awakeFromNib {
    // Initialization code
    self.clipsToBounds = YES;
    self.meetingDetailTextView.textContainer.lineFragmentPadding = 0.0f;
    self.meetingDetailTextView.textContainerInset = UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    self.meetingChairpersonLabel.text = (self.meeting.isChairPerson) ? NSLocalizedString(@"Chair Person", @"Leader of the AA meeting") : @"";
    self.meetingDetailTextView.text = [self detailText];
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
    if (self.meeting.types.count > 0) {
        NSArray* allTypes = [self.meeting.types allObjects];
        MeetingType* firstType = [allTypes firstObject];
        NSString* typesString = firstType.title;

        for (NSInteger i = 1; i < allTypes.count; i++) {
            MeetingType* type = allTypes[i];
            typesString = [typesString stringByAppendingFormat:@", %@", type.title];
        }
        
        return typesString;
    } else {
        return nil;
    }
}

#pragma mark - Layout

#define TOP_EDGE_PADDING        14.0f
#define BOTTOM_EDGE_PADDING     4.0f
#define LEADING_EDGE_PADDING    14.0f
#define TRAILING_EDGE_PADDING   8.0f

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutTitleLabel];
    [self layoutLocationLabel];
    [self layoutChairpersonLabel];
    [self layoutDetailTextView];
}

- (void)layoutTitleLabel
{
    
    CGRect meetingTitleLabelFrame = CGRectMake(self.contentView.bounds.origin.x + LEADING_EDGE_PADDING,
                                               self.contentView.bounds.origin.y + TOP_EDGE_PADDING,
                                               self.contentView.bounds.size.width - (LEADING_EDGE_PADDING + TRAILING_EDGE_PADDING),
                                               [self heightForLabel:self.meetingTitleLabel font:[UIFont stepsHeaderFont]]);
    
    self.meetingTitleLabel.frame = meetingTitleLabelFrame;
                
}

- (void)layoutLocationLabel
{
    CGRect meetingLocationLabelFrame = CGRectMake(self.meetingTitleLabel.frame.origin.x,
                                                  CGRectGetMaxY(self.meetingTitleLabel.frame),
                                                  self.contentView.bounds.size.width - (LEADING_EDGE_PADDING + TRAILING_EDGE_PADDING),
                                                  [self heightForLabel:self.meetingLocationLabel font:[UIFont stepsSubheaderFont]]);
    
    self.meetingLocationLabel.frame = meetingLocationLabelFrame;
}

- (void)layoutChairpersonLabel
{
    CGRect meetingChairpersonLabelFrame = CGRectMake(self.meetingTitleLabel.frame.origin.x,
                                                     CGRectGetMaxY(self.meetingLocationLabel.frame),
                                                     self.contentView.bounds.size.width - (LEADING_EDGE_PADDING + TRAILING_EDGE_PADDING),
                                                     [self heightForLabel:self.meetingChairpersonLabel font:[UIFont stepsCaptionFont]]);
    
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

- (CGFloat)heightForLabel:(UILabel*)label font:(UIFont*)font
{
    CGFloat height = [label.text boundingRectWithSize:[self textBoundingSize]
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName : font}
                                              context:nil].size.height;
    
    return ceilf(height);
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


#pragma mark - Class Methods

+ (CGFloat)heightForCell:(AAMeetingInfoTableViewCell*)cell
{
    CGFloat height = TOP_EDGE_PADDING + BOTTOM_EDGE_PADDING;
    
    height += [cell heightForLabel:cell.meetingTitleLabel font:[UIFont stepsHeaderFont]];
    height += [cell heightForLabel:cell.meetingLocationLabel font:[UIFont stepsSubheaderFont]];
    height += [cell heightForLabel:cell.meetingChairpersonLabel font:[UIFont stepsCaptionFont]];
    height += [cell heightForTextView:cell.meetingDetailTextView font:[UIFont stepsBodyFont]];
    
    return height;
}

@end
