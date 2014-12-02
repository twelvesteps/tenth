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
    self.translatesAutoresizingMaskIntoConstraints = NO;
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
    [self setNeedsUpdateConstraints];
}

#pragma mark - Update Views

- (void)updateViews
{
    self.meetingTitleLabel.text = self.meeting.title;
    self.meetingLocationLabel.text = self.meeting.address;
    self.meetingChairpersonLabel.text = (self.meeting.isChairPerson) ? NSLocalizedString(@"Chair Person", @"Leader of the AA meeting") : @"";
    self.meetingDetailTextView.text = [self detailText];
}

- (NSString*)detailText
{
    NSString* detailText = [self.meeting dayOfWeekString];
    detailText = [detailText stringByAppendingFormat:@"\n%@ - %@", [self.meeting startTimeString], [self.meeting endTimeString]];
    detailText = [detailText stringByAppendingFormat:@"\n%@", [self meetingTypesString]];
    
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

#pragma mark - Autolayout Constraints

#define TOP_EDGE_PADDING        4.0f
#define BOTTOM_EDGE_PADDING     4.0f
#define LEADING_EDGE_PADDING    14.0f
#define TRAILING_EDGE_PADDING   8.0f

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.contentView removeConstraints:self.contentView.constraints]; // clear out old constraints
    
    NSArray* constraints = [self createConstraints];
    [self.contentView addConstraints:constraints];
}

- (NSArray*)createConstraints
{
    NSArray* constraints = [self layoutConstraintsForMeetingTitleLabel];
    constraints = [constraints arrayByAddingObjectsFromArray:[self layoutConstraintsForLabel:self.meetingLocationLabel
                                                                                   belowView:self.meetingTitleLabel
                                                                                        font:[UIFont stepsSubheaderFont]]];
    constraints = [constraints arrayByAddingObjectsFromArray:[self layoutConstraintsForLabel:self.meetingChairpersonLabel
                                                                                   belowView:self.meetingLocationLabel
                                                                                        font:[UIFont stepsCaptionFont]]];
    constraints = [constraints arrayByAddingObjectsFromArray:[self layoutConstraintsForTextView:self.meetingDetailTextView
                                                                                      belowView:self.meetingChairpersonLabel
                                                                                           font:[UIFont stepsBodyFont]]];
    
    return constraints;
}


- (NSArray*)layoutConstraintsForMeetingTitleLabel
{
    NSLayoutConstraint* labelTopEdgeConstraint = [NSLayoutConstraint constraintWithItem:self.meetingTitleLabel
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f
                                                                               constant:0.0f];
    NSLayoutConstraint* labelLeadingEdgeConstraint = [NSLayoutConstraint constraintWithItem:self.meetingTitleLabel
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                 multiplier:1.0f
                                                                                   constant:LEADING_EDGE_PADDING];
    NSLayoutConstraint* labelTrailingEdgeConstraint = [NSLayoutConstraint constraintWithItem:self.meetingTitleLabel
                                                                                   attribute:NSLayoutAttributeTrailing
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:self.contentView
                                                                                   attribute:NSLayoutAttributeTrailing
                                                                                  multiplier:1.0f
                                                                                    constant:TRAILING_EDGE_PADDING];
    
    return @[labelTopEdgeConstraint, labelLeadingEdgeConstraint, labelTrailingEdgeConstraint];
}

- (NSArray*)layoutConstraintsForLabel:(UILabel*)label belowView:(UIView*)topView font:(UIFont*)font
{
    NSArray* viewConstraints = [self layoutConstraintsForView:label belowView:topView];
    
    CGSize boundingSize = [AAMeetingInfoTableViewCell textBoundingSizeForCell:self];
    NSLayoutConstraint* labelHeightConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f
                                                                              constant:[AAMeetingInfoTableViewCell heightForLabel:label
                                                                                                                     boundingSize:boundingSize
                                                                                                                             font:font]];
    viewConstraints = [viewConstraints arrayByAddingObject:labelHeightConstraint];
    return viewConstraints;
}

- (NSArray*)layoutConstraintsForTextView:(UITextView*)textView belowView:(UIView*)topView font:(UIFont*)font
{
    NSArray* viewConstraints = [self layoutConstraintsForView:textView belowView:topView];
    
    CGSize boundingSize = [AAMeetingInfoTableViewCell textBoundingSizeForCell:self];
    NSLayoutConstraint* textViewHeightConstraint = [NSLayoutConstraint constraintWithItem:textView
                                                                                attribute:NSLayoutAttributeHeight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                               multiplier:1.0f
                                                                                 constant:[AAMeetingInfoTableViewCell heightForTextView:textView
                                                                                                                           boundingSize:boundingSize
                                                                                                                                   font:font]];
    
    viewConstraints = [viewConstraints arrayByAddingObject:textViewHeightConstraint];
    return viewConstraints;
}

- (NSArray*)layoutConstraintsForView:(UIView*)view belowView:(UIView*)topView
{
    NSLayoutConstraint* labelTopEdgeConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:topView
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0f
                                                                               constant:0.0f];
    NSLayoutConstraint* labelLeadingEdgeConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                 multiplier:1.0f
                                                                                   constant:LEADING_EDGE_PADDING];
    NSLayoutConstraint* labelTrailingEdgeConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                                   attribute:NSLayoutAttributeTrailing
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:self.contentView
                                                                                   attribute:NSLayoutAttributeTrailing
                                                                                  multiplier:1.0f
                                                                                    constant:TRAILING_EDGE_PADDING];
    
    return @[labelTopEdgeConstraint, labelLeadingEdgeConstraint, labelTrailingEdgeConstraint];
}


#pragma mark - Class Methods
#pragma mark Layout
// *** CELL LAYOUT ***
// | : Top or Bottom Padding
// - : Trailing or Leading padding
// ------------------------------ // top edge
// |                            |
// -MEETING_TITLE_LABEL         -
// -MEETING_LOCATION_LABEL      -
// -MEETING_CHAIRPERSON_LABEL   -
// -MEETING_DETAIL_TEXTVIEW     -
// |                            |
// ------------------------------

+ (CGFloat)heightForCell:(AAMeetingInfoTableViewCell*)cell
{
    CGFloat height = TOP_EDGE_PADDING + BOTTOM_EDGE_PADDING;
    CGSize contentBoundingSize = [AAMeetingInfoTableViewCell textBoundingSizeForCell:cell];
    
    height += [AAMeetingInfoTableViewCell heightForLabel:cell.meetingTitleLabel boundingSize:contentBoundingSize font:[UIFont stepsHeaderFont]];
    height += [AAMeetingInfoTableViewCell heightForLabel:cell.meetingLocationLabel boundingSize:contentBoundingSize font:[UIFont stepsSubheaderFont]];
    height += [AAMeetingInfoTableViewCell heightForLabel:cell.meetingChairpersonLabel boundingSize:contentBoundingSize font:[UIFont stepsCaptionFont]];
    height += [AAMeetingInfoTableViewCell heightForTextView:cell.meetingDetailTextView boundingSize:contentBoundingSize font:[UIFont stepsBodyFont]];
    
    return height;
}

+ (CGFloat)heightForLabel:(UILabel*)label boundingSize:(CGSize)size font:(UIFont*)font
{
    CGFloat height = [label.text boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName : font}
                                              context:nil].size.height;
    
    return ceilf(height);
}

+ (CGFloat)heightForTextView:(UITextView*)textView boundingSize:(CGSize)size font:(UIFont*)font
{
    CGFloat height = [textView.text boundingRectWithSize:size
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                            context:nil].size.height;
    
    return ceilf(height);
}

+ (CGSize)textBoundingSizeForCell:(AAMeetingInfoTableViewCell*)cell
{
    CGSize boundingSize = CGSizeMake(cell.contentView.bounds.size.width - (LEADING_EDGE_PADDING + TRAILING_EDGE_PADDING), CGFLOAT_MAX);
    return boundingSize;
}

@end
