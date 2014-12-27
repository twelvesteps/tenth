//
//  AAMeetingFormatCircleDecorationView.h
//  Steps
//
//  Created by Tom on 12/27/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingFormat.h"

@interface AAMeetingFormatCircleDecorationView : UIView

@property (nonatomic, strong) MeetingFormat* format;

- (instancetype)initWithFormat:(MeetingFormat*)format;

@end
