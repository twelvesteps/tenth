//
//  AAMeetingViewController.m
//  Steps
//
//  Created by Tom on 11/17/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingViewController.h"

#import "AAMeetingNameTableViewCell.h"
#import "AAMeetingLocationTableViewCell.h"
#import "AAMeetingWeekdayTableViewCell.h"
#import "AAMeetingTimeTableViewCell.h"
#import "AAMeetingDurationTableViewCell.h"

@interface AAMeetingViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editDoneButton; // edit/done button

@end

@implementation AAMeetingViewController

#pragma mark - Lifecycle and Properties

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UI Events


#pragma mark - UITableview Delegate and Datasource

#define NAME_CELL_SECTION       0
#define LOCATION_CELL_SECTION   1
#define WEEKDAY_SECTION         2
#define TIME_SECTION            3
#define DURATION_SECTION        4

#define NAME_REUSE_ID       @"MeetingNameCell"
#define LOCATION_REUSE_ID   @"MeetingLocationCell"
#define WEEKDAY_REUSE_ID    @"MeetingWeekdayCell"
#define TIME_REUSE_ID       @"MeetingTimeCell"
#define DURATION_REUSE_ID   @"MeetingDurationCell"

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        return [self editingCellForRowAtIndexPath:indexPath];
    } else {
        return [self standardCellForRowAtIndexPath:indexPath];
    }
}

#pragma mark Standard Cells
- (UITableViewCell*)standardCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.section) {
        case NAME_CELL_SECTION:
            return [self meetingNameCell];
            
        case LOCATION_CELL_SECTION:
            return [self meetingLocationCell];

        case WEEKDAY_SECTION:
            return [self meetingWeekdayCell];
            
        case TIME_SECTION:
            return [self meetingTimeCell];
            
        case DURATION_SECTION:
            return [self meetingDurationCell];
            
        default:
            return nil;
    }
}

- (AAMeetingNameTableViewCell*)meetingNameCell
{
    return nil;
}

- (AAMeetingLocationTableViewCell*)meetingLocationCell
{
    return nil;
}

- (AAMeetingWeekdayTableViewCell*)meetingWeekdayCell
{
    return nil;
}

- (AAMeetingTimeTableViewCell*)meetingTimeCell
{
    return nil;
}

- (AAMeetingDurationTableViewCell*)meetingDurationCell
{
    return nil;
}


#pragma mark Editing Cells

- (UITableViewCell*)editingCellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}


@end
