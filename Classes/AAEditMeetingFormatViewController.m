//
//  AAEditMeetingFormatViewController.m
//  Steps
//
//  Created by Tom on 12/22/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingFormatViewController.h"
#import "AAEditMeetingFormatCell.h"
#import "AAUserMeetingsManager.h"
@interface AAEditMeetingFormatViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;

@property (strong, nonatomic) NSArray* meetingFormats;

@end

@implementation AAEditMeetingFormatViewController

- (NSArray*)meetingFormats
{
    if (!_meetingFormats) {
        _meetingFormats = [[AAUserMeetingsManager sharedManager] fetchMeetingFormats];
    }
    
    return _meetingFormats;
}

- (MeetingFormat*)format
{
    if (self.selectedIndexPath) {
        return [self.meetingFormats objectAtIndex:self.selectedIndexPath.row];
    } else {
        return nil;
    }
}

- (void)setFormat:(MeetingFormat *)format
{
    if (format) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:[self.meetingFormats indexOfObject:format] inSection:0];
    } else {
        self.selectedIndexPath = nil;
    }
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

- (AASeparatorTableViewCell*)separatorCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAEditMeetingFormatCell* cell = (AAEditMeetingFormatCell*)[self.tableView dequeueReusableCellWithIdentifier:FORMAT_CELL_REUSE_ID];
    
    cell.formatLabel.format = self.meetingFormats[indexPath.row];
    cell.formatLabel.decorationAlignment = AADecorationAlignmentLeft;
    cell.formatLabel.textAlignment = AATextAlignmentLeft;
    
    if ([indexPath isEqual:self.selectedIndexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.selectedIndexPath]) {
        self.selectedIndexPath = nil;
    } else {
        self.selectedIndexPath = indexPath;
    }
    
    [self.formatDelegate formatViewDidSelectFormatType:self];
    [self.tableView reloadData];
}

@end
