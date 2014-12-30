//
//  AAEditMeetingPropertyTableViewDelegate.m
//  Steps
//
//  Created by Tom on 12/30/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingPropertyTableViewDelegate.h"

@implementation AAEditMeetingPropertyTableViewDelegate

+ (instancetype)meetingPropertyDelegateWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:AA_EDIT_MEETING_PROPERTY_FORMAT_IDENTIFIER]) {
        
    }
    
    if ([identifier isEqualToString:AA_EDIT_MEETING_PROPERTY_PROGRAM_IDENTIFIER]) {
        
    }
    
    if ([identifier isEqualToString:AA_EDIT_MEETING_PROPERTY_LOCATION_IDENTIFIER]) {
        
    }
    
    return nil;
}

- (BOOL)shouldContinueUpdatingProperty
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %s in a subclass", __PRETTY_FUNCTION__] userInfo:nil];
}

- (void)updateMeetingPropertyWithIndexPaths:(NSArray *)indexPaths
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %s in a subclass", __PRETTY_FUNCTION__] userInfo:nil];
}

@end
