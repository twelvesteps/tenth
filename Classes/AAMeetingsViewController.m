//
//  AAMeetingsViewController.m
//  Steps
//
//  Created by Tom on 11/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserMeetingsManager.h"
#import "AAUserSettingsManager.h"

#import "AAMeetingsViewController.h"
#import "AAMeetingViewController.h"
#import "AAEditMeetingViewController.h"

#import "AAMeetingTableViewCell.h"
#import "AAMeetingSectionDividerView.h"
#import "AAMeetingFellowshipIcon.h"

#import "Meeting+AAAdditions.h"
#import "NSDate+AAAdditions.h"
#import "UIColor+AAAdditions.h"

@interface AAMeetingsViewController () <AAEditMeetingViewControllerDelegate>

// Consists of seven arrays representing the days of the week.
// Meetings are separated by weekday and sorted by startDate.
// If a weekday has no meetings its array will empty
@property (strong, nonatomic) NSMutableArray* meetings;

// Only the meetings to be displayed on screen
@property (strong, nonatomic) NSArray* filteredMeetings;

@end

@implementation AAMeetingsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateMeetings];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateMeetings];
    [self.tableView reloadData];
}


#pragma mark - Meeting Parsing and Filtering

- (void)updateMeetings
{
    NSArray* allMeetings = [[AAUserMeetingsManager sharedManager] fetchMeetings];
    self.meetings = [self parseMeetingsByStartDate:allMeetings];
    self.filteredMeetings = [self filterEmptyMeetings];
}

- (NSMutableArray*)parseMeetingsByStartDate:(NSArray*)meetings
{
    NSMutableArray* mutableParsedMeetings = [[NSMutableArray alloc] init];
    
    // create empty mutable arrays for each weekday
    for (NSInteger i = 0; i < 7; i++) {
        NSMutableArray* weekdayArray = [[NSMutableArray alloc] init];
        [mutableParsedMeetings addObject:weekdayArray];
    }
    
    for (Meeting* meeting in meetings) {
        NSInteger weekdayIndex = [meeting.startDate weekday] - 1;
        NSMutableArray* weekdayArray = mutableParsedMeetings[weekdayIndex];
        [weekdayArray addObject:meeting];
    }
    
    return mutableParsedMeetings;
}

- (NSArray*)filterEmptyMeetings
{
    NSMutableArray* filteredMeetings = [[NSMutableArray alloc] init];
    for (NSArray* weekdayMeetings in self.meetings) {
        if (weekdayMeetings.count > 0) {
            [filteredMeetings addObject:weekdayMeetings];
        }
    }
    
    return [filteredMeetings copy];
}

#pragma mark - UI Events

- (IBAction)weekdaySegementedControlTapped:(UISegmentedControl *)sender
{
    [self updateMeetings];
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.filteredMeetings.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self meetingCountForSection:section];
}

- (NSInteger)meetingCountForSection:(NSInteger)section
{
    NSArray* sectionMeetings = self.filteredMeetings[section];
    return sectionMeetings.count;
}

#define HEADER_VIEW_HEIGHT  30.0f
#define TABLE_CELL_HEIGHT   52.0f

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_VIEW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_HEIGHT;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray* weekdayMeetings = self.filteredMeetings[section];
    Meeting* meeting = [weekdayMeetings firstObject];
    NSInteger weekdayIndex = [meeting.startDate weekday] - 1;
    
    CGRect headerViewFrame = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT);
    AAMeetingSectionDividerView* headerView = [[AAMeetingSectionDividerView alloc] initWithFrame:headerViewFrame];

    headerView.titleLabel.text = [NSCalendar autoupdatingCurrentCalendar].weekdaySymbols[weekdayIndex];
    
    return headerView;
}

#define MEETING_CELL_REUSE_ID       @"MeetingCell"

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self meetingCellForIndexPath:indexPath];
}

- (AAMeetingTableViewCell*)meetingCellForIndexPath:(NSIndexPath*)indexPath
{
    AAMeetingTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:MEETING_CELL_REUSE_ID];
    
    // Last cell in the section should not have a separator
    if (indexPath.row == [self meetingCountForSection:indexPath.section] - 1) {
        cell.bottomSeparator = NO;
    }
    
    Meeting* meeting = [self meetingForIndexPath:indexPath];
    cell.meeting = meeting;
    
    return cell;
}

- (Meeting*)meetingForIndexPath:(NSIndexPath*)indexPath
{
    NSArray* sectionMeetings = self.filteredMeetings[indexPath.section];
    if (sectionMeetings.count > indexPath.row) {
        return sectionMeetings[indexPath.row];
    } else {
        return nil;
    }
}

- (void)deleteMeetingAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray* weekdayMeetings = self.filteredMeetings[indexPath.section];
    Meeting* meeting = weekdayMeetings[indexPath.row];
    
    NSMutableArray* sectionMeetings = self.meetings[[meeting.startDate weekday] - 1];
    [sectionMeetings removeObjectAtIndex:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Meeting* meeting = [self meetingForIndexPath:indexPath];
        [[AAUserMeetingsManager sharedManager] removeMeeting:meeting];
        
        
        if ([self meetingCountForSection:indexPath.section] == 1) {
            [self deleteMeetingAtIndexPath:indexPath];
            self.filteredMeetings = [self filterEmptyMeetings];

            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self deleteMeetingAtIndexPath:indexPath];
            self.filteredMeetings = [self filterEmptyMeetings];

            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }        
    }
}


#pragma mark - Edit Meeting View Controller

- (void)viewControllerDidCancel:(AAEditMeetingViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewControllerDidFinish:(AAEditMeetingViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

#define NEW_MEETING_SEGUE_IDENTIFIER    @"newMeeting"
#define MEETING_DETAIL_SEGUE_IDENTIFIER @"setMeeting"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:NEW_MEETING_SEGUE_IDENTIFIER]) {
    // The "+" button was tapped, create a new meeting
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navController = (UINavigationController*)segue.destinationViewController;
            if ([navController.topViewController isKindOfClass:[AAEditMeetingViewController class]]) {
                AAEditMeetingViewController* aaemvc = (AAEditMeetingViewController*)navController.topViewController;
                aaemvc.delegate = self;
            }
        }
    } else if ([segue.identifier isEqualToString:MEETING_DETAIL_SEGUE_IDENTIFIER]) {
    // A meeting cell was tapped, display the meeting
        if ([segue.destinationViewController isKindOfClass:[AAMeetingViewController class]]) {
            AAMeetingViewController* aamvc = (AAMeetingViewController*)segue.destinationViewController;
            if ([sender isKindOfClass:[AAMeetingTableViewCell class]]) {
                AAMeetingTableViewCell* cell = (AAMeetingTableViewCell*)sender;
                aamvc.meeting = cell.meeting;
            }
        }
    }
}


@end
