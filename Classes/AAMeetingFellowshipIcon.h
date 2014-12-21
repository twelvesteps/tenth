//
//  AAMeetingFellowshipIcon.h
//  Steps
//
//  Created by Tom on 12/7/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting+AAAdditions.h"

@class MeetingProgram;
@class MeetingFormat;

@interface AAMeetingFellowshipIcon : UIView

@property (nonatomic) MeetingFormat* format;
@property (nonatomic) MeetingProgram* program;
@property (nonatomic) BOOL isOpen;

@end
