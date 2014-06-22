//
//  AAPopoverListView.h
//  Steps
//
//  Created by tom on 6/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAPopoverListView;
@protocol AAPopoverListViewDelegate <NSObject>

- (void)popoverView:(AAPopoverListView*)pv buttonTappedAtIndex:(NSInteger)index;
- (void)popoverViewWasDismissed:(AAPopoverListView*)pv;

@end
@interface AAPopoverListView : UIView

// The point in the superview pointed to by the top of the triangle
@property (nonatomic) CGPoint triangleOrigin;
// An array of UIButton objecs or descendents
@property (strong, nonatomic) NSArray* buttons;
// Title is not visible, it is used for identifying the popover list.
@property (strong, nonatomic) NSString* title;

// Customizing Appearance
@property (strong, nonatomic) UIFont* buttonFont; // Default is [UIFont systemFontOfSize:17.0f];

@property (strong, nonatomic) UIColor* menuColor; // Default is [UIColor blackColor];
@property (nonatomic) CGFloat menuAlpha; // Default is 0.9f

@property (strong, nonatomic) UIColor* separatorColor; // Default is [UIColor whiteColor];
@property (nonatomic) CGFloat separatorAlpha; // Default is 1.0f
@property (nonatomic) CGFloat separatorWidth; // Default is 1.0f

@property (weak, nonatomic) id<AAPopoverListViewDelegate> delegate;


// info:    Creates a new AAPopoverListView that determines its own size based on the default settings for buttonFont and
//          button heights. This method is best used when presenting a popover list underneath a standard UIBarButtonItem.
//          Using it with non-standard navigation bars or bar button items could result in unexpected layouts.
//          This method does not check that the frame it creates fits within boundaries of the device it is called.
// returns: A new AAPopoverListView with the standard frame.
+ (AAPopoverListView*)popoverViewPointToNavigationItem:(UIBarButtonItem*)item
                                         navigationBar:(UINavigationBar*)navigationBar
                                      withButtonTitles:(NSArray*)titles;

// info:    Creates a new AAPopoverListView with the given frame and triangle origin. The frame should
//          include space to draw the triangle. The triangleOrigin's x coordinate should be offset from
//          the frame by at least 5 points.
// returns: A new AAPopoverListView with the given properties
// use:     AAPopoverListView* view = [AAPopoverListView alloc] initWithFrame:frame triangleOrigin:pointInFrame;
- (AAPopoverListView*)initWithFrame:(CGRect)frame withTriangleOrigin:(CGPoint)triangleOrigin buttonTitles:(NSArray*)titles;

// info:    The title for the button at the given index.
// returns: The requested title or nil if the given button does not have a title.
// use:     NSString* selectedButtonTitle = [view titleForButtonAtIndex:selectedButtonIndex];
- (NSString*)buttonTitleAtIndex:(NSUInteger)index;

- (void)showInView:(UIView*)view animated:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
