//
//  AAInterceptTouchesView.h
//  Steps
//
//  Created by tom on 6/22/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAInterceptTouchesView;
@protocol AAInterceptTouchesViewDelegate <NSObject>

- (void)interceptTouchesView:(AAInterceptTouchesView*)view didInterceptTouches:(NSSet*)touches;

@end

@interface AAInterceptTouchesView : UIView

@property (weak, nonatomic) id<AAInterceptTouchesViewDelegate> delegate;

@end
