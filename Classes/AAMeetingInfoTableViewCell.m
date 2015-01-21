//
//  AAMeetingInfoTableViewCell.m
//  Steps
//
//  Created by Tom on 11/27/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserSettingsManager.h"

#import "TTTAddressFormatter.h"

#import "Meeting.h"
#import "Location.h"

#import "AAMeetingInfoTableViewCell.h"
#import "AAMeetingProgramDecorationView.h"
#import "AAMeetingFormatLabel.h"

#import "UIFont+AAAdditions.h"
#import "UIColor+AAAdditions.h"
#import "NSDateFormatter+AAAdditions.h"

@interface AAMeetingInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *meetingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingLocationLabel;
@property (weak, nonatomic) IBOutlet AAMeetingFormatLabel *meetingFormatLabel;
@property (weak, nonatomic) IBOutlet UITextView *meetingDetailTextView;

@property (weak, nonatomic) IBOutlet AAMeetingProgramDecorationView *programDecorationView;

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
    self.bottomSeparator = YES;
    
    self.meetingDetailTextView.textContainer.lineFragmentPadding = 0.0f;
    self.meetingDetailTextView.textContainerInset = UIEdgeInsetsZero;
    
    self.meetingFormatLabel.decorationAlignment = AADecorationAlignmentLeft;
    self.meetingTitleLabel.font = [UIFont stepsHeaderFont];
    self.meetingLocationLabel.font = [UIFont stepsSubheaderFont];
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
    self.meetingLocationLabel.text = [self stringFromLocation:self.meeting.location];
    self.meetingFormatLabel.format = [self.meeting.formats anyObject];
    self.meetingDetailTextView.text = [self detailText];
    self.programDecorationView.program = self.meeting.program;
    self.programDecorationView.isOpen = self.meeting.isOpenValue;
}

- (NSString*)detailText
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    NSString* detailText = [formatter stepsDayOfWeekStringFromDate:self.meeting.startDate];
    detailText = [detailText stringByAppendingFormat:@"\n%@ - %@", [formatter stepsTimeStringFromDate:self.meeting.startDate], [formatter stepsTimeStringFromDate:self.meeting.endDate]];
    
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

- (NSString*)stringFromLocation:(Location*)location
{
    return self.meeting.location.title;
}

#pragma mark - Layout

#define TOP_EDGE_PADDING        20.0f
#define BOTTOM_EDGE_PADDING     8.0f
#define LEADING_EDGE_PADDING    14.0f
#define TRAILING_EDGE_PADDING   8.0f

#define VERTICAL_PADDING        4.0f

#define FELLOWSHIP_ICON_WIDTH   32.0f
#define FELLOWSHIP_ICON_HEIGHT  32.0f


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutTitleLabel];
    [self layoutLocationLabel];
    [self layoutFormatLabel];
    [self layoutDetailTextView];
    [self layoutProgramDecorationView];
}

- (void)layoutTitleLabel
{
    CGSize labelSize = [self sizeForLabel:self.meetingTitleLabel
                                     font:[UIFont stepsHeaderFont]
                             boundingSize:[self titleAndLocationLabelTextBoundingSize]];
    
    CGRect meetingTitleLabelFrame = CGRectMake(self.bounds.origin.x + LEADING_EDGE_PADDING,
                                               self.bounds.origin.y + TOP_EDGE_PADDING,
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
                                                  CGRectGetMaxY(self.meetingTitleLabel.frame) + VERTICAL_PADDING,
                                                  labelSize.width,
                                                  labelSize.height);
    
    self.meetingLocationLabel.frame = meetingLocationLabelFrame;
}

- (void)layoutFormatLabel
{
    CGFloat formatLabelWidth = [self.meetingFormatLabel sizeWithBoundingSize:CGSizeMake(self.bounds.size.width - (LEADING_EDGE_PADDING + TRAILING_EDGE_PADDING), CGFLOAT_MAX)].width;
    CGRect meetingChairpersonLabelFrame = CGRectMake(self.meetingTitleLabel.frame.origin.x,
                                                     CGRectGetMaxY(self.meetingLocationLabel.frame) + VERTICAL_PADDING,
                                                     formatLabelWidth,
                                                     23.0f);
    
    self.meetingFormatLabel.frame = meetingChairpersonLabelFrame;
}

- (void)layoutDetailTextView
{
    CGRect meetingDetailTextViewFrame = CGRectMake(self.meetingTitleLabel.frame.origin.x,
                                                   CGRectGetMaxY(self.meetingFormatLabel.frame) + VERTICAL_PADDING,
                                                   self.bounds.size.width - (LEADING_EDGE_PADDING + TRAILING_EDGE_PADDING),
                                                   [self heightForTextView:self.meetingDetailTextView font:[UIFont stepsBodyFont]]);
    
    self.meetingDetailTextView.frame = meetingDetailTextViewFrame;
}

- (void)layoutProgramDecorationView
{
    CGFloat iconOriginX = MAX(CGRectGetMaxX(self.meetingTitleLabel.frame), CGRectGetMaxX(self.meetingLocationLabel.frame)) + TRAILING_EDGE_PADDING;
    CGFloat iconOriginY = (self.meetingTitleLabel.frame.origin.y + CGRectGetMaxY(self.meetingLocationLabel.frame)) / 2.0f - FELLOWSHIP_ICON_HEIGHT / 2.0f;
    
    CGRect programDecorationViewFrame = CGRectMake(iconOriginX,
                                            iconOriginY,
                                            FELLOWSHIP_ICON_WIDTH,
                                            FELLOWSHIP_ICON_HEIGHT);
    
    self.programDecorationView.frame = programDecorationViewFrame;
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
    CGSize boundingSize = CGSizeMake(self.bounds.size.width - (LEADING_EDGE_PADDING + TRAILING_EDGE_PADDING), CGFLOAT_MAX);
    return boundingSize;
}

- (CGSize)titleAndLocationLabelTextBoundingSize
{
    CGFloat trailingEdgeInset = 2 * TRAILING_EDGE_PADDING + FELLOWSHIP_ICON_WIDTH;
    CGSize boundingSize = CGSizeMake(self.bounds.size.width - (LEADING_EDGE_PADDING + trailingEdgeInset), CGFLOAT_MAX);
    return boundingSize;
}


#pragma mark - Class Methods

+ (CGFloat)heightForCell:(AAMeetingInfoTableViewCell*)cell
{
    CGFloat height = TOP_EDGE_PADDING + BOTTOM_EDGE_PADDING + 3 * VERTICAL_PADDING;
    
    height += [cell sizeForLabel:cell.meetingTitleLabel font:[UIFont stepsHeaderFont] boundingSize:[cell titleAndLocationLabelTextBoundingSize]].height;
    height += [cell sizeForLabel:cell.meetingLocationLabel font:[UIFont stepsSubheaderFont] boundingSize:[cell titleAndLocationLabelTextBoundingSize]].height;
    height += 23.0f;
    height += [cell heightForTextView:cell.meetingDetailTextView font:[UIFont stepsBodyFont]];
    
    return height;
}

@end
