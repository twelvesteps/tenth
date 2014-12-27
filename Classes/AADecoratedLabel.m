//
//  AADecoratedLabel.m
//  Steps
//
//  Created by Tom on 12/27/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AADecoratedLabel.h"
@interface AADecoratedLabel()

@property (nonatomic, weak) UILabel* textLabel;

@end

@implementation AADecoratedLabel

#pragma mark - Lifecycle

#define DEFAULT_DECORATION_SPACING      8.0f
#define DECORATION_VIEW_FRAME_KEYPATH   @"frame"

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

- (void)setup
{
    _decorationAlignment = AADecorationAlignmentLeft;
    _textAlignment = AATextAlignmentLeft;
    _decorationSpacing = DEFAULT_DECORATION_SPACING;
    _insets = UIEdgeInsetsZero;
    
}


- (void)dealloc
{
    [self.decorationView removeObserver:self forKeyPath:DECORATION_VIEW_FRAME_KEYPATH];
}

#pragma mark - PROPERTIES

#pragma mark Decoration View Properties

- (void)setDecorationView:(UIView *)decorationView
{
    if (self.decorationView) {
        [self.decorationView removeObserver:self forKeyPath:DECORATION_VIEW_FRAME_KEYPATH];
        
        [self.decorationView removeFromSuperview];
    }
    
    [self addSubview:decorationView];
    [decorationView addObserver:self forKeyPath:DECORATION_VIEW_FRAME_KEYPATH options:NSKeyValueObservingOptionNew context:nil];
    _decorationView = decorationView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:DECORATION_VIEW_FRAME_KEYPATH]) {
        [self setNeedsLayout];
    }
}


#pragma mark Text Properties

- (UILabel*)textLabel
{
    if (!_textLabel) {
        UILabel* textLabel = [[UILabel alloc] init];
        textLabel.textColor = [UIColor darkTextColor];
        textLabel.font = [UIFont systemFontOfSize:13.0f];
        textLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:textLabel];
        _textLabel = textLabel;
    }
    
    return _textLabel;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textLabel.textColor = textColor;
}

- (UIColor*)textColor
{
    return self.textLabel.textColor;
}

- (void)setFont:(UIFont *)font
{
    self.textLabel.font = font;
    [self setNeedsLayout];
}

- (UIFont*)font
{
    return self.textLabel.font;
}

#pragma mark Layout Properties

- (void)setInsets:(UIEdgeInsets)insets
{
    _insets = insets;
    
    [self setNeedsLayout];
}

- (void)setDecorationSpacing:(CGFloat)decorationSpacing
{
    _decorationSpacing = decorationSpacing;
    
    [self setNeedsLayout];
}

- (void)setTextAlignment:(AATextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    
    [self setNeedsLayout];
}

- (void)setDecorationAlignment:(AADecorationAlignment)decorationAlignment
{
    _decorationAlignment = decorationAlignment;
    
    [self setNeedsLayout];
}


#pragma mark - LAYOUT

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self layoutTextLabel];
    [self layoutDecorationView];
}

#pragma mark Layout Text Label
- (void)layoutTextLabel
{
    CGSize textLabelSize = [self textLabelSize];
    CGPoint textLabelOrigin = [self textLabelOriginForSize:textLabelSize];
    
    CGRect textLabelFrame = CGRectMake(textLabelOrigin.x, textLabelOrigin.y, textLabelSize.width, textLabelSize.height);
    self.textLabel.frame = textLabelFrame;
}

- (CGSize)textLabelSize
{
    CGSize boundingSize = CGSizeMake(self.bounds.size.width - (self.decorationView.frame.size.width + self.insets.left + self.insets.right + self.decorationSpacing) ,
                                     self.bounds.size.height);
    boundingSize.width = MAX(boundingSize.width, 0.0f); // make sure bounding size is not negative
    
    CGSize textSize = [self.text boundingRectWithSize:boundingSize
                                              options:0
                                           attributes:@{NSFontAttributeName : self.font}
                                              context:nil].size;
    textSize.width = MIN(ceilf(textSize.width), ceilf(boundingSize.width));
    textSize.height = MIN(ceilf(textSize.height), ceilf(boundingSize.height));
    
    // return minimum in case text size is larger than bounds
    return textSize;
}

- (CGPoint)textLabelOriginForSize:(CGSize)size
{
    CGPoint textLabelOrigin = CGPointMake([self textLabelOriginXForWidth:size.width],
                                          [self textLabelOriginYForHeight:size.height]);
    
    return textLabelOrigin;
}

- (CGFloat)textLabelOriginXForWidth:(CGFloat)width
{
    CGFloat originX = 0.0f;
    switch (self.textAlignment) {
        case AATextAlignmentLeft:
            if (self.decorationAlignment == AADecorationAlignmentLeft) {
                originX = ceilf(self.bounds.origin.x + self.insets.left + self.decorationView.frame.size.width + self.decorationSpacing);
            } else {
                // AADecorationAlignmentRight
                originX = ceilf(self.bounds.origin.x + self.insets.left);
            }
            
        case AATextAlignmentCenter: {
            CGFloat decorationAndSpacingWidth = self.decorationView.frame.size.width + self.decorationSpacing;
            CGFloat decorationAndTextWidth = width + decorationAndSpacingWidth;
            if (self.decorationAlignment == AADecorationAlignmentLeft) {
                originX = ceilf((CGRectGetMaxX(self.bounds) - decorationAndTextWidth) / 2.0f - decorationAndSpacingWidth);
            } else {
                originX = ceilf((CGRectGetMaxX(self.bounds) - decorationAndTextWidth) / 2.0f);
            }
        }
            
            
        case AATextAlignmentRight:
            if (self.decorationAlignment == AADecorationAlignmentLeft) {
                originX = ceilf(CGRectGetMaxX(self.bounds) - (width + self.insets.right));
            } else {
                originX = ceilf(CGRectGetMaxX(self.bounds) - (width + self.insets.right + self.decorationSpacing + self.decorationView.frame.size.width));
            }
    }
    
    DLog(@"<DEBUG> Decorated label text origin x: %f", originX);
    return originX;
}

- (CGFloat)textLabelOriginYForHeight:(CGFloat)height
{
    CGFloat originY = ceilf((self.bounds.size.height - height) / 2.0f);
    DLog(@"<DEBUG> Decorated label text origin y: %f", originY);
    return originY;
}


#pragma mark Layout Decoration View
- (void)layoutDecorationView
{
    CGRect decorationViewFrame = self.decorationView.frame;
    decorationViewFrame.origin = [self decorationViewOrigin];
    self.decorationView.frame = decorationViewFrame;
}

- (CGPoint)decorationViewOrigin
{
    CGPoint decorationViewOrigin = CGPointZero;
    if (self.decorationAlignment == AADecorationAlignmentLeft) {
        decorationViewOrigin = CGPointMake(self.textLabel.frame.origin.x - (self.decorationView.frame.size.width + self.decorationSpacing),
                                           self.bounds.origin.y + (self.bounds.size.height - self.decorationView.frame.size.height) / 2.0f);
    } else {
        decorationViewOrigin = CGPointMake(CGRectGetMaxX(self.textLabel.frame) + self.decorationView.frame.size.width + self.decorationSpacing,
                                           self.bounds.origin.y + (self.bounds.size.height - self.decorationView.frame.size.height) / 2.0f);
    }
    
    return decorationViewOrigin;
}

@end
