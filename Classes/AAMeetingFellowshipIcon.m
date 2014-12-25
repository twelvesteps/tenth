//
//  AAMeetingFellowshipIcon.m
//  Steps
//
//  Created by Tom on 12/7/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingFellowshipIcon.h"

#import "AAUserSettingsManager.h"

#import "UIFont+AAAdditions.h"
#import "UIColor+AAAdditions.h"


@interface AAMeetingFellowshipIcon()

@property (weak, nonatomic) UILabel* fellowshipNameLabel;
@property (strong, nonatomic) UIColor* color;

@end

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

- (void)setFormat:(MeetingFormat*)format
{
    _format = format;
    [self updateViews];
}

- (void)setProgram:(MeetingProgram*)program
{
    _program = program;
    [self updateViews];
}

- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    [self updateViews];
}


- (void)updateViews
{
    NSString* fellowshipShortName = self.program.shortTitle;
    if (fellowshipShortName.length >= 3) {
        NSUInteger fontCompression = fellowshipShortName.length - 2;
        self.fellowshipNameLabel.font = [UIFont stepsCompressedFont:fontCompression];
    } else {
        self.fellowshipNameLabel.font = [UIFont stepsFooterFont];
    }
    
    self.fellowshipNameLabel.text = fellowshipShortName;
    [self updateLabelColor];
    [self setNeedsDisplay];
}

- (void)updateLabelColor
{
    if (self.isOpen) {
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
    
    switch (self.program.symbolType.integerValue) {
        case AAMeetingProgramSymbolTypeTriangleAroundCircle:
            [self drawCircleInTriangleInRect:rect];
            break;
            
        default:
            [self drawCircleInRect:rect];
            break;
    }
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
    if (self.isOpen) {
        // stroke path
        [self.color setStroke];
        [circlePath setLineWidth:STROKE_LINE_WIDTH];
        [circlePath stroke];
    } else {
        [self.color setFill];
        [circlePath fill];
    }
}

- (void)drawCircleInTriangleInRect:(CGRect)rect
{
    // calculate triangle dimensions based on rect
    CGFloat triangleHeight = ceilf(rect.size.height * sin(M_PI / 3)); // equilateral triangle height
    CGFloat triangleInset = (rect.size.height - triangleHeight) / 2.0f;
    
    // triangle points
    CGPoint firstPoint = CGPointMake(rect.origin.x, CGRectGetMaxY(rect) - triangleInset);
    CGPoint secondPoint = CGPointMake(CGRectGetMidX(rect), firstPoint.y - triangleHeight);
    CGPoint thirdPoint = CGPointMake(CGRectGetMaxX(rect), firstPoint.y);
    
    // circle measurements
    CGPoint circleCenter = CGPointMake(CGRectGetMidX(rect), firstPoint.y  - floor(tan(M_PI / 6) * (rect.size.width / 2.0f)));
    CGFloat circleRadius = triangleHeight / 4.5f;
    CGRect circleRect = CGRectMake(circleCenter.x - circleRadius,
                                   circleCenter.y - circleRadius,
                                   2 * circleRadius,
                                   2 * circleRadius);
    
    // create paths
    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:firstPoint];
    [trianglePath addLineToPoint:secondPoint];
    [trianglePath addLineToPoint:thirdPoint];
    [trianglePath addLineToPoint:firstPoint];
    [trianglePath closePath];
    
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    
    if (self.isOpen) {
        [self.color setStroke];
        [trianglePath stroke];
        
        [self.color setFill];
        [circlePath fill];
    } else {
        [self.color setFill];
        [trianglePath fill];
        
        [[UIColor whiteColor] setFill];
        [circlePath fill];
    }
    
}


@end
