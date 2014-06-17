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

@end
@interface AAPopoverListView : UIView

// The point in the superview pointed to by the top of the triangle
@property (nonatomic) CGPoint triangleOrigin;
// An array of UIButton objecs or descendents
@property (strong, nonatomic) NSArray* buttons;

@property (strong, nonatomic) NSString* title;

@property (weak, nonatomic) id<AAPopoverListViewDelegate> delegate;

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

@end
