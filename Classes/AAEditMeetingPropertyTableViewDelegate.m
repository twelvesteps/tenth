//
//  AAEditMeetingPropertyTableViewDelegate.m
//  Steps
//
//  Created by Tom on 12/30/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingPropertyTableViewDelegate.h"
#import "AAEditMeetingFormatTableViewDelegate.h"
#import "AAEditMeetingProgramTableViewDelegate.h"
#import "AAEditMeetingLocationTableViewDelegate.h"

@implementation AAEditMeetingPropertyTableViewDelegate

#pragma mark - Class Methods

+ (instancetype)meetingPropertyDelegateWithIdentifier:(NSString *)identifier meeting:(Meeting *)meeting
{
    AAEditMeetingPropertyTableViewDelegate* delegate = nil;
    if ([identifier isEqualToString:AA_EDIT_MEETING_PROPERTY_FORMAT_IDENTIFIER]) {
        delegate = [[AAEditMeetingFormatTableViewDelegate alloc] init];
    }
    
    if ([identifier isEqualToString:AA_EDIT_MEETING_PROPERTY_PROGRAM_IDENTIFIER]) {
        delegate = [[AAEditMeetingProgramTableViewDelegate alloc] init];
    }
    
    if ([identifier isEqualToString:AA_EDIT_MEETING_PROPERTY_LOCATION_IDENTIFIER]) {
        delegate = [[AAEditMeetingLocationTableViewDelegate alloc] init];
    }
    
    delegate.meeting = meeting;
    
    return delegate;
}

#pragma mark - Tableview Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    throwAbstractMethodException;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    throwAbstractMethodException;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    throwAbstractMethodException;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    throwAbstractMethodException;
}

@end
