//
//  AAMeetingFormatCircleDecorationView.m
//  Steps
//
//  Created by Tom on 12/27/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingFormatCircleDecorationView.h"
#import "UIColor+AAAdditions.h"

@implementation AAMeetingFormatCircleDecorationView

#define CIRCLE_RADIUS       5.0f

#pragma mark - LIFECYCLE

- (instancetype)initWithFormat:(MeetingFormat *)format
{
    CGRect defaultFrame = CGRectMake(0.0f, 0.0f, 2 * CIRCLE_RADIUS, 2 * CIRCLE_RADIUS);
    self = [super initWithFrame:defaultFrame];
    
    if (self) {
        self.format = format;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


#pragma mark - PROPERTIES

- (void)setFormat:(MeetingFormat *)format
{
    _format = format;
    
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self clearRect:self.bounds];

    [self drawCircle];
}

- (void)clearRect:(CGRect)rect
{
    UIBezierPath* clearPath = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor clearColor] setFill];
    [clearPath fill];
}

- (void)drawCircle
{
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    
    [[UIColor stepsColorForKey:self.format.colorKey] setFill];
    [circlePath fill];
}

@end
