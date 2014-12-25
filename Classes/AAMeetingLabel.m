//
//  AAMeetingLabel.m
//  Steps
//
//  Created by Tom on 12/12/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserSettingsManager.h"
#import "AAMeetingLabel.h"

#import "UIFont+AAAdditions.h"
#import "UIColor+AAAdditions.h"


@interface AAMeetingLabel()

@property (nonatomic, weak) UILabel* titleLabel;

@end


@implementation AAMeetingLabel

#pragma mark - Lifecycle and Properties

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.font = [UIFont stepsCaptionFont];
    self.backgroundColor = [UIColor clearColor];
    self.alignment = AAMeetingLabelAlignmentLeft; // default
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        UILabel* titleLabel = [[UILabel alloc] init];
        
        titleLabel.font = [UIFont stepsCaptionFont];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

        _titleLabel = titleLabel;
        [self addSubview:titleLabel];
    }
    
    return _titleLabel;
}

- (void)setFormat:(MeetingFormat*)format
{
    _format = format;

    [self updateViews];
}

- (void)setText:(NSString *)text
{
    self.titleLabel.text = text;
    
    [self updateViews];
}

- (NSString*)text
{
    return self.titleLabel.text;
}

- (void)setLeftCircle:(BOOL)leftCircle
{
    _leftCircle = leftCircle;
    
    [self updateViews];
}

- (void)setAlignment:(AAMeetingLabelAlignment)alignment
{
    _alignment = alignment;
    
    [self updateViews];
}

- (void)updateViews
{
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

#pragma mark - Layout

#define CIRCLE_RADIUS       5.0f
#define CIRCLE_VIEW_WIDTH   18.0f

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutTitleLabel];
}

- (void)layoutTitleLabel
{

    
    CGSize boundingSize = [self labelBoundingSize];
    
    CGSize labelSize = [AAMeetingLabel labelSizeForText:self.titleLabel.text boundingSize:boundingSize font:self.titleLabel.font];

    CGFloat titleLabelOriginX = [self titleLabelOriginXForSize:labelSize];

    
    CGFloat titleLabelOriginY = self.bounds.origin.y + (self.bounds.size.height - labelSize.height) / 2.0f;
    
    CGRect titleLabelFrame = CGRectMake(titleLabelOriginX,
                                        titleLabelOriginY,
                                        labelSize.width,
                                        labelSize.height);
    
    self.titleLabel.frame = titleLabelFrame;
}

- (CGFloat)titleLabelOriginXForSize:(CGSize)boundingSize
{
    CGFloat titleLabelOriginX;
    switch (self.alignment) {
        case AAMeetingLabelAlignmentLeft:
            titleLabelOriginX = self.bounds.origin.x;
            if (self.leftCircle) {
                titleLabelOriginX += CIRCLE_VIEW_WIDTH;
            }
            break;
            
        case AAMeetingLabelAlignmentCenter:
            titleLabelOriginX = CGRectGetMidX(self.bounds) - boundingSize.width / 2.0f;
            if (self.leftCircle) {
                titleLabelOriginX += (CIRCLE_VIEW_WIDTH / 2.0f);
            } else {
                titleLabelOriginX -= (CIRCLE_VIEW_WIDTH / 2.0f);
            }
            break;
            
        case AAMeetingLabelAlignmentRight:
            titleLabelOriginX = CGRectGetMaxX(self.bounds) - boundingSize.width;
            if (!self.leftCircle) {
                titleLabelOriginX -= CIRCLE_VIEW_WIDTH;
            }
            break;
            
        default:
            DLog(@"<DEBUG> Meeting label's alignment property not correctly set");
    }
    
    return titleLabelOriginX;
}

- (CGSize)labelBoundingSize
{
    CGSize boundingSize = self.frame.size; // bounds are not guaranteed to be set
    boundingSize.width -= CIRCLE_VIEW_WIDTH; // subtract the circle's bounding box width
    return boundingSize;
}

+ (CGFloat)heightForText:(NSString *)text boundingSize:(CGSize)boundingSize
{
    return [AAMeetingLabel sizeForText:text boundingSize:boundingSize font:[UIFont stepsCaptionFont]].height;
}

+ (CGFloat)widthForText:(NSString *)text boundingSize:(CGSize)boundingSize
{
    return [AAMeetingLabel widthForText:text boundingSize:boundingSize font:[UIFont stepsCaptionFont]];
}

+ (CGFloat)widthForText:(NSString *)text boundingSize:(CGSize)boundingSize font:(UIFont *)font
{
    return [AAMeetingLabel sizeForText:text boundingSize:boundingSize font:font].width;
}

+ (CGSize)sizeForText:(NSString *)text boundingSize:(CGSize)boundingSize font:(UIFont*)font
{
    boundingSize.width -= CIRCLE_VIEW_WIDTH;
    
    CGSize size = [self labelSizeForText:text boundingSize:boundingSize font:font];
    
    size.width += CIRCLE_VIEW_WIDTH;
    
    return size;
}

+ (CGSize)labelSizeForText:(NSString*)text boundingSize:(CGSize)boundingSize font:(UIFont*)font
{
    if (boundingSize.width > 0 && boundingSize.height > 0) {
        CGSize size = [text boundingRectWithSize:boundingSize
                                         options:0
                                      attributes:@{NSFontAttributeName : font}
                                         context:nil].size;
        // round values for drawing
        size.width = ceilf(size.width);
        size.height = ceilf(size.height);
        
        // text size might be larger than bounding size, use min
        size.width = MIN(boundingSize.width, size.width);
        
        return size;
    } else {
        // bounding size is too small, don't draw label
        return CGSizeZero;
    }
}




#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self clearRect:self.bounds];
    
    if (self.format) {
        [self drawCircle];
    }
}

- (void)clearRect:(CGRect)rect
{
    UIBezierPath* clearPath = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor clearColor] setFill];
    [clearPath fill];
}

- (void)drawCircle
{
    CGFloat circleOriginX;
    if (self.leftCircle) {
        circleOriginX = self.titleLabel.frame.origin.x - CIRCLE_VIEW_WIDTH;
    } else {
        circleOriginX = CGRectGetMaxX(self.titleLabel.frame) + (CIRCLE_VIEW_WIDTH - 2 * CIRCLE_RADIUS);
    }
    
    CGRect circleRect = CGRectMake(circleOriginX,
                                   CGRectGetMidY(self.titleLabel.frame) - CIRCLE_RADIUS,
                                   2 * CIRCLE_RADIUS,
                                   2 * CIRCLE_RADIUS);
    
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    
    [[UIColor stepsColorForKey:self.format.colorKey] setFill];
    [circlePath fill];
}

@end
