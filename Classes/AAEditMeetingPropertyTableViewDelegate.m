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

- (instancetype)initWithPropertyName:(NSString*)name
{
    self = [super init];
    if (self) {
        _propertyName = name;
    }
    
    return self;
}


+ (instancetype)meetingPropertyDelegateWithPropertyName:(NSString *)name meeting:(Meeting *)meeting
{
    DLog(@"<DEBUG> Instantiating property delegate with name: %@", name);
    AAEditMeetingPropertyTableViewDelegate* delegate = nil;
    if ([name isEqualToString:AA_EDIT_MEETING_PROPERTY_FORMAT_NAME]) {
        delegate = [[AAEditMeetingFormatTableViewDelegate alloc] initWithPropertyName:name];
        
    } else if ([name isEqualToString:AA_EDIT_MEETING_PROPERTY_PROGRAM_NAME]) {
        delegate = [[AAEditMeetingProgramTableViewDelegate alloc] initWithPropertyName:name];
        
    } else if ([name isEqualToString:AA_EDIT_MEETING_PROPERTY_LOCATION_NAME]) {
        delegate = [[AAEditMeetingLocationTableViewDelegate alloc] initWithPropertyName:name];
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
    // no op
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end
