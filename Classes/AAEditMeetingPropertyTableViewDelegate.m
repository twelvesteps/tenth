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

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
}

#pragma mark - Instance Methods

- (AASeparatorTableViewCell*)separatorCellForIndexPath:(NSIndexPath *)indexPath
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %s in a subclass", __PRETTY_FUNCTION__] userInfo:nil];
}

- (void)updateMeetingPropertyWithIndexPaths:(NSArray *)indexPaths
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %s in a subclass", __PRETTY_FUNCTION__] userInfo:nil];
}

#pragma mark - Tableview Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %s in a subclass", __PRETTY_FUNCTION__] userInfo:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %s in a subclass", __PRETTY_FUNCTION__] userInfo:nil];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %s in a subclass", __PRETTY_FUNCTION__] userInfo:nil];
}

@end
