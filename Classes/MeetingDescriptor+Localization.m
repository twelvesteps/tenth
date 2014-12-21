//
//  MeetingDescriptor+Localization.m
//  Steps
//
//  Created by Tom on 12/20/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "MeetingDescriptor+Localization.h"

@implementation MeetingDescriptor (Localization)

- (NSString*)localizedTitle
{
    return NSLocalizedString(self.title, @"Localized descriptor title");
}

@end
