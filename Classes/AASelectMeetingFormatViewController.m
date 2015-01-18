//
//  AASelectMeetingFormatViewController.m
//  Steps
//
//  Created by Tom on 1/18/15.
//  Copyright (c) 2015 spitzgoby LLC. All rights reserved.
//

#import "AASelectMeetingFormatViewController.h"

#warning Change 'edit' to 'select'
#import "AAEditMeetingFormatCell.h"

#import "AAUserMeetingsManager.h"

#define MEETING_FORMAT_SECTION  0
#define ADD_FORMAT_SECTION      1
#define FORMAT_CELL_REUSE_ID        @"MeetingFormatCell"


@interface AASelectMeetingFormatViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* meetingFormats;
@property (nonatomic, strong) NSMutableArray* selectedIndexPaths;

@end

@implementation AASelectMeetingFormatViewController

#pragma mark - Lifecycle


#pragma mark - Properties

@synthesize meeting = _meeting;

- (NSMutableArray*)selectedIndexPaths
{
    if (!_selectedIndexPaths) {
        _selectedIndexPaths = [[NSMutableArray alloc] init];
    }
    
    return _selectedIndexPaths;
}

- (NSArray*)meetingFormats
{
    if (!_meetingFormats) {
        _meetingFormats = [[AAUserMeetingsManager sharedManager] fetchMeetingFormats];
    }
    
    return _meetingFormats;
}

- (void)setMeeting:(Meeting *)meeting
{
    _meeting = meeting;
    
    [self.selectedIndexPaths removeAllObjects];
    for (MeetingFormat* format in meeting.formats) {
        NSInteger formatIndex = [self.meetingFormats indexOfObject:format];
        [self.selectedIndexPaths addObject:[NSIndexPath indexPathForRow:formatIndex inSection:0]];
    }
}

#pragma mark AAGroupedTableView Overrides

- (AASeparatorTableViewCell*)separatorCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self meetingFormatCellForRowAtIndexPath:indexPath];
}

- (AAEditMeetingFormatCell*)meetingFormatCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingFormatCell* cell = (AAEditMeetingFormatCell*)[self.tableView dequeueReusableCellWithIdentifier:FORMAT_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingFormatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FORMAT_CELL_REUSE_ID];
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(AAEditMeetingFormatCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    cell.formatLabel.format = self.meetingFormats[indexPath.row];
    cell.formatLabel.decorationAlignment = AADecorationAlignmentLeft;
    cell.formatLabel.textAlignment = AATextAlignmentLeft;
    
    cell.accessoryType = [self accessoryTypeForRowWithIndexPath:indexPath];
    
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


#pragma mark - Tableview Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isEditing) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isEditing && section == ADD_FORMAT_SECTION) {
        return 1;
    } else {
        return self.meetingFormats.count;
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
