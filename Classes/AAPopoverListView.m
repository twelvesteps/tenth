//
//  AAPopoverListView.m
//  Steps
//
//  Created by tom on 6/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAPopoverListView.h"
#import "AAInterceptTouchesView.h"
#import "UIColor+AAAdditions.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_MENU_ALPHA          0.9f
#define DEFAULT_SEPARATOR_ALPHA     1.0f

#define TRIANGLE_HEIGHT             5.0f
#define ROUNDED_RECT_CORNER_RADII   3.0f
#define DEFAULT_SEPARATOR_WIDTH     1.0f

#define DEFAULT_BUTTON_HEIGHT       44.0f
#define DEFAULT_BUTTON_INSET        8.0f
#define DEFAULT_FONT_SIZE           17.0f

#define DEFAULT_ANIMATION_DURATION  0.2f

@interface AAPopoverListView () <AAInterceptTouchesViewDelegate>

@property (strong, nonatomic) NSArray* titles;
@property (weak, nonatomic) AAInterceptTouchesView* interceptView;

@end

@implementation AAPopoverListView

#pragma mark - Initialization

- (AAPopoverListView*)initWithFrame:(CGRect)frame withTriangleOrigin:(CGPoint)triangleOrigin buttonTitles:(NSArray *)titles
{
    self = [self initWithFrame:frame];
    if (self) {
        self.triangleOrigin = triangleOrigin;
        self.titles = titles;
        // set defaults
        self.backgroundColor = [UIColor clearColor];
        self.menuColor = [UIColor blackColor];
        self.menuAlpha = DEFAULT_MENU_ALPHA;
        self.separatorColor = [UIColor whiteColor];
        self.separatorAlpha = DEFAULT_SEPARATOR_ALPHA;
        self.separatorWidth = DEFAULT_SEPARATOR_WIDTH;
        self.buttonFont = [UIFont systemFontOfSize:17.0f];
    }
    
    return self;
}

+ (AAPopoverListView*)popoverViewPointToNavigationItem:(UIBarButtonItem *)item
                                         navigationBar:(UINavigationBar *)navigationBar
                                      withButtonTitles:(NSArray *)titles
{
    // NOTE: Undocumented API for UIBarButtonItem
    UIView* itemView = (UIView*)[item valueForKey:@"view"];
    
    CGPoint triangleOrigin = CGPointMake(itemView.center.x, CGRectGetMaxY(navigationBar.frame) + TRIANGLE_HEIGHT);
    CGFloat popoverWidth = [AAPopoverListView popoverViewWidthForTitles:titles withFont:[UIFont systemFontOfSize:DEFAULT_FONT_SIZE]];
    CGFloat popoverHeight = [AAPopoverListView popoverViewHeightForTitles:titles];
    CGFloat popoverOriginX = [AAPopoverListView popoverViewOriginXForNavigationItem:item navigationBar:navigationBar withWidth:popoverWidth];
    CGRect popoverFrame = CGRectMake(popoverOriginX,
                                     triangleOrigin.y,
                                     popoverWidth,
                                     popoverHeight);
    
    AAPopoverListView* popoverView = [[AAPopoverListView alloc] initWithFrame:popoverFrame withTriangleOrigin:triangleOrigin buttonTitles:titles];
    
    return popoverView;
}

- (NSArray*)buttons
{
    if (!_buttons) {
        [self addButtonsWithTitles:self.titles];
    }
    
    return _buttons;
}


#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_buttons) {
        [self addButtonsWithTitles:self.titles];
    }
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
        
        DLog(@"<DEBUG> Popover button frame: %@", NSStringFromCGRect(buttonFrame));
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = self.buttonFont;
        button.titleLabel.textColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(listButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [buttons addObject:button];
    }
    
    _buttons = [buttons copy];
}

+ (CGFloat)popoverViewWidthForTitles:(NSArray*)titles withFont:(UIFont*)font
{
    CGFloat width = 0.0f;
    
    for (NSString* title in titles) {
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: font}];
        if (titleSize.width > width) {
            width = ceilf(titleSize.width);
        }
    }
    
    return width + 2 * DEFAULT_BUTTON_INSET;
}

+ (CGFloat)popoverViewHeightForTitles:(NSArray*)titles
{
    return titles.count * DEFAULT_BUTTON_HEIGHT + TRIANGLE_HEIGHT;
}

+ (CGFloat)popoverViewOriginXForNavigationItem:(UIBarButtonItem*)item
                                 navigationBar:(UINavigationBar*)navigationBar
                                     withWidth:(CGFloat)width
{
    UIView* itemView = (UIView*)[item valueForKey:@"view"];
    CGFloat popoverOriginX = 0.0;
    if (itemView.frame.origin.x < navigationBar.center.x) {
        popoverOriginX = navigationBar.frame.origin.x + DEFAULT_BUTTON_INSET;
    } else {
        popoverOriginX = CGRectGetMaxX(navigationBar.frame) - (width + DEFAULT_BUTTON_INSET);
    }
    
    return popoverOriginX;
}


#pragma mark - UIEvents

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
}

- (NSString*)buttonTitleAtIndex:(NSUInteger)index
{
    if (index >= self.buttons.count) {
        return nil;
    }
    
    UIButton* button = self.buttons[index];
    return button.titleLabel.text;
}

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    [self addInterceptViewToView:view];
    [view addSubview:self];
    if (animated) {
        [self animateFateIn];
    }
}

- (void)hide:(BOOL)animated
{
    if (self.interceptView) {
        [self removeInterceptView];
    }
    
    if (animated) {
        [self animateFadeOut];
    } else {
        [self removeFromSuperview];
    }
}

- (void)addInterceptViewToView:(UIView*)view
{
    AAInterceptTouchesView* interceptView = [[AAInterceptTouchesView alloc] initWithFrame:view.bounds];
    interceptView.delegate = self;
    [view addSubview:interceptView];
    
    self.interceptView = interceptView;
}

- (void)removeInterceptView
{
    [self.interceptView removeFromSuperview];
    self.interceptView = nil;
}

- (void)animateFateIn
{
    self.alpha = 0.0f;
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
        self.alpha = 1.0f;
    }];
}

- (void)animateFadeOut
{
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


#pragma mark - AAInterceptTouchesView Delegate

- (void)interceptTouchesView:(AAInterceptTouchesView *)view didInterceptTouches:(NSSet *)touches
{
    [self removeInterceptView];
    [self.delegate popoverViewWasDismissed:self];
}

#pragma mark - Drawing

- (void)drawTriangle
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    CGPoint triangleUpperCorner = [self convertPoint:self.triangleOrigin fromView:self.superview];
    CGPoint triangleLowerLeft   = CGPointMake(triangleUpperCorner.x - TRIANGLE_HEIGHT, triangleUpperCorner.y + TRIANGLE_HEIGHT);
    CGPoint triangleLowerRight  = CGPointMake(triangleUpperCorner.x + TRIANGLE_HEIGHT, triangleUpperCorner.y + TRIANGLE_HEIGHT);
    
    DLog(@"<DEBUG> Popover triangle top corner: %@", NSStringFromCGPoint(triangleUpperCorner));
    DLog(@"<DEBUG> Popover triangle left corner: %@", NSStringFromCGPoint(triangleLowerLeft));
    DLog(@"<DEBUG> Popover triangle right corner: %@", NSStringFromCGPoint(triangleLowerRight));
    
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
    DLog(@"<DEBUG> Popover rect frame: %@", NSStringFromCGRect(roundedRectFrame));
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:roundedRectFrame cornerRadius:ROUNDED_RECT_CORNER_RADII];
    [path fill];
}

- (void)drawSeparators
{
    CGPoint separatorOrigin = CGPointMake(self.bounds.origin.x,
                                          self.bounds.origin.y + TRIANGLE_HEIGHT);
    CGPoint separatorEnd = CGPointMake(separatorOrigin.x + self.bounds.size.width,
                                       separatorOrigin.y);
    
    [[UIColor colorWithUIColor:self.separatorColor withAlpha:self.separatorAlpha] setStroke];
    for (NSInteger i = 0; i < self.buttons.count - 1; i++) {
        UIBezierPath* path = [UIBezierPath bezierPath];
        path.lineWidth = self.separatorWidth;

        separatorOrigin.y += DEFAULT_BUTTON_HEIGHT;
        separatorEnd.y += DEFAULT_BUTTON_HEIGHT;

        DLog(@"<DEBUG> Separator Origin: %@", NSStringFromCGPoint(separatorOrigin));
        DLog(@"<DEBUG> Separator End: %@", NSStringFromCGPoint(separatorEnd));

        [path moveToPoint:separatorOrigin];
        [path addLineToPoint:separatorEnd];
        [path closePath];
        
        [path stroke];
    }
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor colorWithUIColor:self.menuColor withAlpha:self.menuAlpha] setFill];
    [self drawTriangle];
    [self drawRoundedRect];
    [self drawSeparators];
}

@end
