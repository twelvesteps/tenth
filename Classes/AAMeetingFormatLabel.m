//
//  AAMeetingFormatLabel.m
//  Steps
//
//  Created by Tom on 12/12/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingFormatLabel.h"
#import "AAMeetingFormatCircleDecorationView.h"

@implementation AAMeetingFormatLabel

- (void)setFormat:(MeetingFormat*)format
{
    _format = format;
    
    AAMeetingFormatCircleDecorationView* decorationView = [[AAMeetingFormatCircleDecorationView alloc] initWithFormat:self.format];
    self.decorationView = decorationView;
    
    if (_format) {
        self.text = format.localizedTitle;
    } else {
        self.text = NSLocalizedString(@"None", @"No format has been selected for the meeting");
    }
}


@end
