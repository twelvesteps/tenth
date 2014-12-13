//
//  AAMeetingLabel.m
//  Steps
//
//  Created by Tom on 12/12/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingLabel.h"

#import "AAUserSettingsManager.h"
#import "UIFont+AAAdditions.h"
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
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        UILabel* titleLabel = [[UILabel alloc] init];
        
        titleLabel.font = [UIFont stepsCaptionFont];

        _titleLabel = titleLabel;
        [self addSubview:titleLabel];
    }
    
    return _titleLabel;
}

- (void)setFormat:(AAMeetingFormat)format
{
    _format = format;

    [self updateViews];
}

- (void)setText:(NSString *)text
{
    self.titleLabel.text = text;
    
    [self updateViews];
}

- (void)updateViews
{
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (NSString*)text
{
    return self.titleLabel.text;
}


#pragma mark - Layout

#define CIRCLE_RADIUS       5.0f
#define CIRCLE_VIEW_WIDTH   14.0f

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutTitleLabel];
}

- (void)layoutTitleLabel
{
    CGFloat titleLabelOriginX = self.bounds.origin.x;
    if (self.leftCircle) {
        titleLabelOriginX = self.bounds.origin.x + CIRCLE_VIEW_WIDTH;
    }
    
    CGSize boundingSize = self.bounds.size;
    boundingSize.width -= CIRCLE_VIEW_WIDTH;
    CGSize labelSize = [AAMeetingLabel labelSizeForText:self.titleLabel.text boundingSize:boundingSize font:self.titleLabel.font];
    
    CGFloat titleLabelOriginY = self.bounds.origin.y + (self.bounds.size.height - labelSize.height) / 2.0f;
    
    CGRect titleLabelFrame = CGRectMake(titleLabelOriginX,
                                        titleLabelOriginY,
                                        labelSize.width,
                                        labelSize.height);
    
    self.titleLabel.frame = titleLabelFrame;
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
    CGSize size = [text boundingRectWithSize:boundingSize
                                     options:0
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil].size;
    size.width = ceilf(size.width);
    size.height = ceilf(size.height);
    
    return size;
}




#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self clearRect:self.bounds];
    
    if (self.format != AAMeetingFormatUnspecified) {
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
        circleOriginX = self.bounds.origin.x;
    } else {
        circleOriginX = self.titleLabel.frame.origin.x + (CIRCLE_VIEW_WIDTH - 2 * CIRCLE_RADIUS);
    }
    
    CGRect circleRect = CGRectMake(circleOriginX,
                                   CGRectGetMidY(self.titleLabel.frame) - CIRCLE_RADIUS,
                                   2 * CIRCLE_RADIUS,
                                   2 * CIRCLE_RADIUS);
    
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    
    [[[AAUserSettingsManager sharedManager] colorForMeetingFormat:self.format] setFill];
    [circlePath fill];
}

@end
