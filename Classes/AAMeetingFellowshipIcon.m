//
//  AAMeetingFellowshipIcon.m
//  Steps
//
//  Created by Tom on 12/7/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingFellowshipIcon.h"
#import "UIColor+AAAdditions.h"
#import "UIFont+AAAdditions.h"

@implementation AAMeetingFellowshipIcon

#pragma mark - Lifecycle and Properties

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

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
    [self initFellowshipNameLabel];
    
    self.backgroundColor = [UIColor whiteColor];
    self.color = [UIColor stepsBlueColor];
}

- (void)initFellowshipNameLabel
{
    UILabel* fellowshipNameLabel = [[UILabel alloc] init];
    fellowshipNameLabel.font = [UIFont stepsFooterFont];
    fellowshipNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:fellowshipNameLabel];
    self.fellowshipNameLabel = fellowshipNameLabel;

}

- (void)setOpenMeeting:(BOOL)openMeeting
{
    _openMeeting = openMeeting;
    
    [self updateLabelColor];
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    
    [self updateLabelColor];
    [self setNeedsDisplay];
}

- (void)updateLabelColor
{
    if (_openMeeting) {
        self.fellowshipNameLabel.textColor = self.color;
    } else {
        self.fellowshipNameLabel.textColor = [UIColor whiteColor];
    }
}


#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutFellowshipNameLabel];
}

- (void)layoutFellowshipNameLabel
{
    CGFloat labelHeight = ceilf([self.fellowshipNameLabel.text boundingRectWithSize:self.bounds.size
                                                                            options:0
                                                                         attributes:@{NSFontAttributeName : self.fellowshipNameLabel.font}
                                                                            context:nil].size.height);
    
    CGRect fellowshipNameLabelFrame = CGRectMake(0.0f,
                                                 self.bounds.origin.y + (self.bounds.size.height - labelHeight) / 2.0f,
                                                 self.bounds.size.width,
                                                 labelHeight);
    
    self.fellowshipNameLabel.frame = fellowshipNameLabelFrame;
}


#pragma mark - Drawing

#define STROKE_LINE_WIDTH   2.0f

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self clearRect:rect];
    [self drawCircleInRect:rect];
}

- (void)clearRect:(CGRect)rect
{
    UIBezierPath* rectPath = [UIBezierPath bezierPathWithRect:rect];
    [self.backgroundColor setFill];
    [rectPath fill];
}

- (void)drawCircleInRect:(CGRect)rect
{
    CGFloat halfStrokeLineWidth = STROKE_LINE_WIDTH / 2.0f;
    CGRect shrunkRect = CGRectMake(rect.origin.x + halfStrokeLineWidth,
                                   rect.origin.y + halfStrokeLineWidth,
                                   rect.size.width - STROKE_LINE_WIDTH,
                                   rect.size.height - STROKE_LINE_WIDTH);
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:shrunkRect];
    if (self.openMeeting) {
        // stroke path
        [self.color setStroke];
        [circlePath setLineWidth:STROKE_LINE_WIDTH];
        [circlePath stroke];
    } else {
        [self.color setFill];
        [circlePath fill];
    }
}


@end
