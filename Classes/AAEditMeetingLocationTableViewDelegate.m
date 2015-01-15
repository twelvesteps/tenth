//
//  AAEditMeetingLocationTableViewDelegate.m
//  Steps
//
//  Created by Tom on 12/30/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingLocationTableViewDelegate.h"
#import "AAMeetingDescriptorTableViewCell.h"

#import "AAUserMeetingsManager.h"

@interface AAEditMeetingLocationTableViewDelegate()

@property (nonatomic, strong) NSArray* locations;

@property (nonatomic, strong) NSIndexPath* selectedIndexPath;

@end

@implementation AAEditMeetingLocationTableViewDelegate

#pragma mark - Properties

- (NSArray*)locations
{
    if (!_locations) {
        _locations = [[AAUserMeetingsManager sharedManager] fetchLocations];
    }
    
    return _locations;
}

@synthesize meeting = _meeting;
- (void)setMeeting:(Meeting *)meeting
{
    _meeting = meeting;
    
    if (meeting) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:[self.locations indexOfObject:meeting.location] inSection:0];
    } else {
        self.selectedIndexPath = nil;
    }
}

- (BOOL)isEditable
{
    return YES;
}


#pragma mark - Tableview Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAMeetingDescriptorTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:AA_MEETING_DESCRIPTOR_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAMeetingDescriptorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AA_MEETING_DESCRIPTOR_CELL_REUSE_ID];
    }
    
    if ([self.selectedIndexPath isEqual:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedIndexPath isEqual:indexPath]) {
        self.selectedIndexPath = nil;
        self.meeting.location = nil;
    } else {
        self.selectedIndexPath = indexPath;
        self.meeting.location = self.locations[indexPath.row];
    }

    [tableView reloadData];
}

@end
