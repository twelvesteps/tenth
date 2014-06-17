//
//  AAPopoverListView.m
//  Steps
//
//  Created by tom on 6/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAPopoverListView.h"
#import <QuartzCore/QuartzCore.h>

#define TRIANGLE_HEIGHT             5.0f
#define ROUNDED_RECT_CORNER_RADII   2.0f
#define SEPARATOR_WIDTH             2.0f
#define DEFAULT_BUTTON_HEIGHT       44.0f

@interface AAPopoverListView ()

@property (strong, nonatomic) NSArray* titles;

@end

@implementation AAPopoverListView

- (AAPopoverListView*)initWithFrame:(CGRect)frame withTriangleOrigin:(CGPoint)triangleOrigin buttonTitles:(NSArray *)titles
{
    self = [self initWithFrame:frame];
    if (self) {
        self.triangleOrigin = triangleOrigin;
        self.backgroundColor = [UIColor clearColor];
        self.titles = titles;
    }
    
    return self;
}

- (void)addButtonsWithTitles:(NSArray*)titles
{
    NSMutableArray* buttons = [[NSMutableArray alloc] init];

    CGFloat currentHeightOffset = 5.0f;
    for (NSString* title in titles) {
        CGRect buttonFrame = CGRectMake(self.bounds.origin.x,
                                        self.bounds.origin.y + currentHeightOffset,
                                        self.bounds.size.width,
                                        DEFAULT_BUTTON_HEIGHT);
        currentHeightOffset += DEFAULT_BUTTON_HEIGHT;
        
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        button.titleLabel.textColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(listButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [buttons addObject:button];
    }

    self.buttons = [buttons copy];
}

- (void)listButtonTapped:(UIButton*)sender
{
    NSInteger buttonIndex = -1;
    for (NSInteger i = 0; i < self.buttons.count && buttonIndex < 0; i++) {
        UIButton* current = self.buttons[i];
        if ([current isEqual:sender]) {
            buttonIndex = i;
        }
    }
    
    [self.delegate popoverView:self buttonTappedAtIndex:buttonIndex];
    [self removeFromSuperview];
}

- (NSString*)buttonTitleAtIndex:(NSUInteger)index
{
    if (index >= self.buttons.count) {
        return nil;
    }
    
    UIButton* button = self.buttons[index];
    return button.titleLabel.text;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.buttons) {
        [self addButtonsWithTitles:self.titles];
    }
}


- (void)drawTriangle
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    CGPoint triangleUpperCorner = [self convertPoint:self.triangleOrigin fromView:self.superview];
    CGPoint triangleLowerLeft   = CGPointMake(triangleUpperCorner.x - TRIANGLE_HEIGHT, triangleUpperCorner.y + TRIANGLE_HEIGHT);
    CGPoint triangleLowerRight  = CGPointMake(triangleUpperCorner.x + TRIANGLE_HEIGHT, triangleUpperCorner.y + TRIANGLE_HEIGHT);
    
    [path moveToPoint:triangleUpperCorner];
    [path addLineToPoint:triangleLowerLeft];
    [path addLineToPoint:triangleLowerRight];
    [path addLineToPoint:triangleUpperCorner];
    [path closePath];
    
    [path fill];
}

- (void)drawRoundedRect
{
    CGRect roundedRectFrame = CGRectMake(self.bounds.origin.x,
                                         self.bounds.origin.y + TRIANGLE_HEIGHT,
                                         self.bounds.size.width,
                                         self.bounds.size.height - TRIANGLE_HEIGHT);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:roundedRectFrame cornerRadius:ROUNDED_RECT_CORNER_RADII];
    [path fill];
}

- (void)drawSeparators
{
    CGPoint separatorOrigin = CGPointMake(self.bounds.origin.x,
                                          self.bounds.origin.y + TRIANGLE_HEIGHT);
    CGPoint separatorEnd = CGPointMake(separatorOrigin.x + self.bounds.size.width,
                                       separatorOrigin.y);
    
    [[UIColor whiteColor] setStroke];
    for (NSInteger i = 0; i < self.buttons.count - 1; i++) {
        UIBezierPath* path = [UIBezierPath bezierPath];
        path.lineWidth = SEPARATOR_WIDTH;

        separatorOrigin.y += DEFAULT_BUTTON_HEIGHT;
        separatorEnd.y += DEFAULT_BUTTON_HEIGHT;
        
        [path moveToPoint:separatorOrigin];
        [path addLineToPoint:separatorEnd];
        [path closePath];
        
        [path stroke];
    }
}



- (void)drawRect:(CGRect)rect
{
    [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9f] setFill];
    [self drawTriangle];
    [self drawRoundedRect];
    [self drawSeparators];
}


@end
