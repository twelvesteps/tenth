//
//  AAMeetingProgramDecorationView.h
//  Steps
//
//  Created by Tom on 12/7/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAMeetingDescriptorDecorationView.h"

@class MeetingProgram;
@class MeetingFormat;

@interface AAMeetingProgramDecorationView : AAMeetingDescriptorDecorationView

@property (nonatomic) MeetingProgram* program;
@property (nonatomic) BOOL isOpen;

@end
