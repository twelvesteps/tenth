//
//  AAEditMeetingPickerCell.m
//  Steps
//
//  Created by Tom on 12/1/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingPickerCell.h"
#import "UIFont+AAAdditions.h"
#import "UIColor+AAAdditions.h"


@interface AAEditMeetingPickerCell()

@property (nonatomic, weak) UIView* labelSeparatorView;
@property (nonatomic, weak) UIView* pickerSeparatorView;

@end

@implementation AAEditMeetingPickerCell

#pragma mark - Lifecycle and Properties

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setup];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    [self initLabels];
    [self initPicker];

    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
}

- (void)setPickerHidden:(BOOL)pickerHidden
{
    _pickerHidden = pickerHidden;
    
    [self updateLabels];
    [self setNeedsLayout];
}

- (void)updateLabels
{
    if (self.pickerHidden) {
        self.descriptionLabel.textColor = [UIColor darkTextColor];
    } else {
        self.descriptionLabel.textColor = [UIColor stepsBlueColor];
    }
}


#pragma mark - Init Subviews

- (void)initLabels
{
    UILabel* titleLabel = [[UILabel alloc] init];
    UILabel* descriptionLabel = [[UILabel alloc] init];
    
    titleLabel.font = [UIFont stepsCaptionFont];
    descriptionLabel.font = [UIFont stepsCaptionFont];
    
    titleLabel.textAlignment = NSTextAlignmentLeft;
    descriptionLabel.textAlignment = NSTextAlignmentRight;
    
    self.titleLabel = titleLabel;
    self.descriptionLabel = descriptionLabel;
    
    [self addSubview:titleLabel];
    [self addSubview:descriptionLabel];
}

- (void)initPicker
{
    if (!self.picker) {
        UIPickerView* picker = [[UIPickerView alloc] init];
        
        self.picker = picker;
        [self addSubview:picker];
    }
}

- (NSInteger)separatorsCount
{
    if (self.bottomSeparator) {
        return 2;
    } else {
        return 1;
    }
}


- (NSArray*)separatorOrigins
{
    NSMutableArray* origins = [[NSMutableArray alloc] init];
    CGFloat originX = self.bounds.origin.x + SEPARATOR_INSET;
    
    [origins addObject:[NSValue valueWithCGPoint:CGPointMake(originX, LABEL_BLOCK_HEIGHT - SEPARATOR_HEIGHT)]];
    
    if (self.bottomSeparator) {
        [origins addObject:[NSValue valueWithCGPoint:CGPointMake(originX, CGRectGetMaxY(self.bounds) - SEPARATOR_HEIGHT)]];
    }
    
    return [origins copy];
}

#pragma mark - Layout

#define PICKER_BLOCK_HEIGHT     216.0f

#define LABEL_LEFT_PADDING      14.0f
#define LABEL_RIGHT_PADDING     8.0f
#define LABEL_SPACING           8.0f

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutLabels];
    [self layoutPicker];
}

- (void)layoutLabels
{
    CGSize titleLabelSize = [self intrinsicSizeForLabel:self.titleLabel];
    CGSize descriptionLabelSize = [self intrinsicSizeForLabel:self.titleLabel];
    
    
    CGRect titleLabelFrame = CGRectMake(self.bounds.origin.x + LABEL_LEFT_PADDING,
                                        LABEL_BLOCK_HEIGHT / 2.0f - titleLabelSize.height / 2.0f,
                                        titleLabelSize.width,
                                        titleLabelSize.height);
    
    CGFloat descriptionLabelWidth = self.bounds.size.width - (CGRectGetMaxX(titleLabelFrame) + LABEL_SPACING + LABEL_RIGHT_PADDING);
    CGRect descriptionLabelFrame = CGRectMake(CGRectGetMaxX(titleLabelFrame) + LABEL_SPACING,
                                              titleLabelFrame.origin.y,
                                              descriptionLabelWidth,
                                              descriptionLabelSize.height);
    
    self.titleLabel.frame = titleLabelFrame;
    self.descriptionLabel.frame = descriptionLabelFrame;
}

- (void)layoutPicker
{
    CGRect pickerFrame = CGRectMake(self.bounds.origin.x,
                                    self.bounds.origin.y + LABEL_BLOCK_HEIGHT,
                                    self.bounds.size.width,
                                    PICKER_BLOCK_HEIGHT);
    
    self.picker.frame = pickerFrame;
}

- (CGSize)intrinsicSizeForLabel:(UILabel*)label
{
    CGSize labelSize = [label.text boundingRectWithSize:self.bounds.size
                                                options:0
                                             attributes:@{NSFontAttributeName : label.font}
                                                context:nil].size;
    
    labelSize = CGSizeMake(ceilf(labelSize.width), ceilf(labelSize.height));
    return labelSize;
}

@end
