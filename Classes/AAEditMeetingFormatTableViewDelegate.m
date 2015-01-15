//
//  AAEditMeetingFormatTableViewDelegate.m
//  Steps
//
//  Created by Tom on 12/30/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingFormatTableViewDelegate.h"

#import "AAUserMeetingsManager.h"

#import "AAEditMeetingFormatCell.h"

@interface AAEditMeetingFormatTableViewDelegate()

@property (nonatomic, strong) NSArray* meetingFormats;
@property (nonatomic, strong) NSMutableArray* selectedIndexPaths;

@end


@implementation AAEditMeetingFormatTableViewDelegate

- (NSArray*)meetingFormats
{
    if (!_meetingFormats) {
        _meetingFormats = [[AAUserMeetingsManager sharedManager] fetchMeetingFormats];
    }
    
    return _meetingFormats;
}

- (NSMutableArray*)selectedIndexPaths
{
    if (!_selectedIndexPaths) {
        _selectedIndexPaths = [[NSMutableArray alloc] init];
    }
    
    return _selectedIndexPaths;
}

@synthesize meeting = _meeting;
- (void)setMeeting:(Meeting *)meeting
{
    _meeting = meeting;
    if (meeting) {
        for (MeetingFormat* format in meeting.formats) {
            NSInteger formatIndex = [self.meetingFormats indexOfObject:format];
            [self.selectedIndexPaths addObject:[NSIndexPath indexPathForRow:formatIndex inSection:0]];
        }
    }
}

- (BOOL)isEditable
{
    return YES;
}


#pragma mark - Tableview Delegate and Datasource

#define FORMAT_CELL_REUSE_ID    @"MeetingFormatCell"

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.meetingFormats.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAEditMeetingFormatCell* cell = (AAEditMeetingFormatCell*)[tableView dequeueReusableCellWithIdentifier:FORMAT_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingFormatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FORMAT_CELL_REUSE_ID];
    }
    
    cell.formatLabel.format = self.meetingFormats[indexPath.row];
    cell.formatLabel.decorationAlignment = AADecorationAlignmentLeft;
    cell.formatLabel.textAlignment = AATextAlignmentLeft;
    
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == self.meetingFormats.count - 1) {
        cell.bottomSeparator = NO;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        [self.selectedIndexPaths removeObject:indexPath];
        [self.meeting removeFormatsObject:[self.meetingFormats objectAtIndex:indexPath.row]];
    } else {
        [self.selectedIndexPaths addObject:indexPath];
        [self.meeting addFormatsObject:[self.meetingFormats objectAtIndex:indexPath.row]];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
