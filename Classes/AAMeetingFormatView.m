//
//  AAMeetingFormatView.m
//  Steps
//
//  Created by Tom on 12/11/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingFormatView.h"

#import "AAUserSettingsManager.h"

#import "UIFont+AAAdditions.h"

@interface AAMeetingFormatView()

@property (nonatomic, strong) UIColor* color;
@property (nonatomic, weak) UILabel* formatLabel;

@end

@implementation AAMeetingFormatView

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
    self.backgroundColor = [UIColor whiteColor];
    [self initFormatLabel];
}

- (void)initFormatLabel
{
    UILabel* formatLabel = [[UILabel alloc] init];
    
    formatLabel.font = [UIFont stepsCaptionFont];
    formatLabel.textAlignment = NSTextAlignmentLeft;
    
    self.formatLabel = formatLabel;
    [self addSubview:formatLabel];
}

- (void)setFormat:(AAMeetingFormat)format
{
    _format = format;
    
    self.color = [[AAUserSettingsManager sharedManager] colorForMeetingFormat:format];
    self.formatLabel.text = [Meeting stringForMeetingFormat:format];
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}


#pragma mark - Layout

#define CIRCLE_CONTAINER_WIDTH  23.0f
#define CIRCLE_CONTAINER_HEIGHT 23.0f

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutFormatLabel];
}

- (void)layoutFormatLabel
{
    CGSize formatLabelSize = [self.formatLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CIRCLE_CONTAINER_HEIGHT)
                                                                 options:0
                                                              attributes:@{NSFontAttributeName : self.formatLabel.font}
                                                                 context:nil].size;
    
    formatLabelSize.width = ceilf(formatLabelSize.width);
    formatLabelSize.height = ceilf(formatLabelSize.height);
    
    CGRect formatLabelFrame = CGRectMake(self.bounds.origin.x + CIRCLE_CONTAINER_WIDTH,
                                         self.bounds.origin.y + (self.bounds.size.height - formatLabelSize.height) / 2.0f,
                                         formatLabelSize.width,
                                         formatLabelSize.height);
    
    self.formatLabel.frame = formatLabelFrame;
}

#define CIRCLE_RADIUS   5.0f

- (void)drawRect:(CGRect)rect
{
    CGRect circleRect = CGRectMake(self.bounds.origin.x + (CIRCLE_CONTAINER_WIDTH - (2 * CIRCLE_RADIUS)) / 2.0f,
                                   self.bounds.origin.y + (CIRCLE_CONTAINER_HEIGHT - (2 * CIRCLE_RADIUS)) / 2.0f,
                                   2 * CIRCLE_RADIUS,
                                   2 * CIRCLE_RADIUS);
    
    [self.color setFill];
    [[UIBezierPath bezierPathWithOvalInRect:circleRect] fill];
}


+ (CGFloat)widthForFormat:(AAMeetingFormat)format
{
    NSString* formatString = [Meeting stringForMeetingFormat:format];
    CGFloat width = ceilf([formatString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CIRCLE_CONTAINER_HEIGHT)
                                                     options:0
                                                  attributes:@{NSFontAttributeName : [UIFont stepsCaptionFont]}
                                                     context:nil].size.width) + CIRCLE_CONTAINER_WIDTH;
                                                                      
    return width;
}


@end
