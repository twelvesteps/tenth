//
//  AAMeetingFormatLabel.m
//  Steps
//
//  Created by Tom on 12/12/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingFormatLabel.h"
#import "AAUserSettingsManager.h"

@implementation AAMeetingFormatLabel

@synthesize format = _format;

- (void)setFormat:(AAMeetingFormat)format
{
    _format = format;
    
    self.text = [Meeting stringForMeetingFormat:format];
}

- (BOOL)leftCircle
{
    return YES;
}

@end
