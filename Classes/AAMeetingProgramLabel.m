//
//  AAMeetingProgramLabel.m
//  Steps
//
//  Created by Tom on 1/1/15.
//  Copyright (c) 2015 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingProgramLabel.h"
#import "AAMeetingProgramDecorationView.h"

@implementation AAMeetingProgramLabel

- (void)setProgram:(MeetingProgram *)program
{
    _program = program;
    
    AAMeetingProgramDecorationView* icon = [[AAMeetingProgramDecorationView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    icon.program = program;
    self.decorationView = icon;
    
    self.text = program.shortTitle;
}


@end
