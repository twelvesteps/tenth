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

#import "UIColor+AAAdditions.h"

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

#define ADD_FORMAT_SECTION  1
#define FORMAT_LIST_SECTION 0

#define ADD_FORMAT_CELL_REUSE_ID    @"AddFormatCell"
#define FORMAT_CELL_REUSE_ID        @"MeetingFormatCell"

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.isEditing) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.isEditing && section == ADD_FORMAT_SECTION) {
        return 1;
    } else {
        return self.meetingFormats.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing && indexPath.section == ADD_FORMAT_SECTION) {
        return [self addMeetingFormatCell];
    } else {
        return [self tableView:tableView meetingFormatCellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell*)addMeetingFormatCell
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ADD_FORMAT_CELL_REUSE_ID];
    
    cell.textLabel.text = NSLocalizedString(@"Create New Format", @"Create a new meeting format");
    cell.textLabel.textColor = [UIColor stepsBlueColor];
    
    return cell;
}

- (AAEditMeetingFormatCell*)tableView:(UITableView*)tableView meetingFormatCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingFormatCell* cell = (AAEditMeetingFormatCell*)[tableView dequeueReusableCellWithIdentifier:FORMAT_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingFormatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FORMAT_CELL_REUSE_ID];
    }
    
    [self tableView:tableView configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView*)tableView configureCell:(AAEditMeetingFormatCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    cell.formatLabel.format = self.meetingFormats[indexPath.row];
    cell.formatLabel.decorationAlignment = AADecorationAlignmentLeft;
    cell.formatLabel.textAlignment = AATextAlignmentLeft;
    
    cell.accessoryType = [self accessoryTypeForRowWithIndexPath:indexPath];
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == self.meetingFormats.count - 1) {
        cell.bottomSeparator = NO;
    }
}

- (UITableViewCellAccessoryType)accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        return UITableViewCellAccessoryCheckmark;
    } else {
        return UITableViewCellAccessoryNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == FORMAT_LIST_SECTION;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ADD_FORMAT_SECTION) {
        return UITableViewCellEditingStyleNone;
    } else {
        return (UITableViewCellEditingStyle)3;
    }
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
