//
//  AAEditMeetingProgramTableViewDelegate.m
//  Steps
//
//  Created by Tom on 12/30/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingProgramTableViewDelegate.h"

#import "AAUserMeetingsManager.h"

#import "AAEditMeetingProgramTypeCell.h"

@interface AAEditMeetingProgramTableViewDelegate()

@property (nonatomic, strong) NSArray* meetingPrograms;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;

@end

@implementation AAEditMeetingProgramTableViewDelegate


- (NSArray*)meetingPrograms
{
    if (!_meetingPrograms) {
        _meetingPrograms = [[AAUserMeetingsManager sharedManager] fetchMeetingPrograms];
    }
    
    return _meetingPrograms;
}

@synthesize meeting = _meeting;
- (void)setMeeting:(Meeting *)meeting
{
    _meeting = meeting;
    
    if (meeting.program) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:[self.meetingPrograms indexOfObject:meeting.program] inSection:0];
    } else {
        self.selectedIndexPath = nil;
    }
}

- (BOOL)isEditable
{
    return NO;
}


#pragma mark - Tableview Delegate and Datasource

#define PROGRAM_CELL_REUSE_ID   @"MeetingProgramCell"

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.meetingPrograms.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AASeparatorTableViewCell* cell = (AASeparatorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:PROGRAM_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingProgramTypeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:PROGRAM_CELL_REUSE_ID];
    }
    
    MeetingProgram* program = [self.meetingPrograms objectAtIndex:indexPath.row];
    cell.textLabel.text = program.localizedTitle;
    
    if ([indexPath isEqual:self.selectedIndexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == self.meetingPrograms.count - 1) {
        cell.bottomSeparator = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // grab row index paths to update
    NSMutableArray* indexPaths = [[NSMutableArray alloc] init];
    if (self.selectedIndexPath) {
        [indexPaths addObject:self.selectedIndexPath];
    }
    [indexPaths addObject:indexPath];
    
    self.selectedIndexPath = indexPath;
    self.meeting.program = self.meetingPrograms[indexPath.row];

    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
