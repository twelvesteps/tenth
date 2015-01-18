//
//  AAMeetingDescriptorDecorationView.h
//  Steps
//
//  Created by Tom on 1/18/15.
//  Copyright (c) 2015 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeetingDescriptor;

@interface AAMeetingDescriptorDecorationView : UIView

/**
 *  The descriptor decorated by the view
 */
@property (nonatomic, strong) MeetingDescriptor* descriptor;

/**
 *  Returns the default frame for the decoration view
 *
 *  @return The default frame for the decoration view
 */
+ (CGRect)defaultFrame; // default implementation returns CGRectZero

@end
