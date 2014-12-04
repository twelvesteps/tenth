//
//  AAMeetingViewController.m
//  Steps
//
//  Created by Tom on 11/17/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingViewController.h"
#import "AAMeetingInfoTableViewCell.h"
#import "AAEditMeetingViewController.h"

@interface AAMeetingViewController () <AAEditMeetingViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editDoneButton; // edit/done button

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@end

@implementation AAMeetingViewController

#pragma mark - UI Events


#pragma mark - UITableview Delegate and Datasource

#define MEETING_INFO_CELL_REUSE_ID  @"MeetingInfoCell"

#define MEETING_INFO_CELL_SECTION   0
#define MEETING_INFO_CELL_ROW       0

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self meetingInfoCellForIndexPath:indexPath];
}

- (AAMeetingInfoTableViewCell*)meetingInfoCellForIndexPath:(NSIndexPath*)indexPath
{
    AAMeetingInfoTableViewCell* cell = (AAMeetingInfoTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:MEETING_INFO_CELL_REUSE_ID];
    
    cell.meeting = self.meeting;
    
    return cell;
}


#pragma mark - Edit Meeting View Controller Delegate

- (void)viewControllerDidCancel:(AAEditMeetingViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewControllerDidFinish:(AAEditMeetingViewController *)vc
{
    self.meeting = vc.meeting;
    
    AAMeetingInfoTableViewCell* cell = (AAMeetingInfoTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:MEETING_INFO_CELL_ROW
                                                                                                                              inSection:MEETING_INFO_CELL_SECTION]];
    cell.meeting = vc.meeting;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

#define EDIT_MEETING_SEGUE_ID   @"setMeeting"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:EDIT_MEETING_SEGUE_ID]) {
        if ([segue.destinationViewController isKindOfClass:[AAEditMeetingViewController class]]) {
            AAEditMeetingViewController* aaemvc = (AAEditMeetingViewController*)segue.destinationViewController;
            
            aaemvc.meeting = self.meeting;
            aaemvc.delegate = self;
        }
    }
}

@end
