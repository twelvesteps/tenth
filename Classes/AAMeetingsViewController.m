//
//  AAMeetingsViewController.m
//  Steps
//
//  Created by Tom on 11/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingsViewController.h"
#import "AAMeetingViewController.h"
#import "AAUserDataManager.h"
#import "AAMeetingTableViewCell.h"
#import "AAEditMeetingViewController.h"
#import "AAMeetingSectionDividerView.h"

#import "Meeting+AAAdditions.h"
#import "NSDate+AAAdditions.h"
#import "UIColor+AAAdditions.h"

@interface AAMeetingsViewController () <AAEditMeetingViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray* meetings; // an array of arrays, sorted by start date of meetings
@property (strong, nonatomic) NSArray* filteredMeetings; // an array of arrays containing visible meetings

@property (weak, nonatomic) IBOutlet UISegmentedControl *weekdaySegmentedControl;

@end

@implementation AAMeetingsViewController

#define SHOW_ALL_WEEKDAYS_INDEX     -1
#define ALL_WEEKDAYS_SEGMENT_INDEX  0

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateMeetings];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateMeetings];
}

- (void)updateMeetings
{
    NSArray* allMeetings = [[AAUserDataManager sharedManager] fetchMeetings];
    self.meetings = [self parseMeetingsByStartDate:allMeetings];
    self.filteredMeetings = [self filteredMeetingsForSelectedWeekday:self.weekdaySegmentedControl.selectedSegmentIndex - 1];
}


#pragma mark - Meeting Parsing and Filtering

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
        
//        if (mutableParsedMeetings.count == 0) { // No meetings have been parsed, add current meeting
//            NSMutableArray* firstMeeting = [@[meeting] mutableCopy];
//            [mutableParsedMeetings addObject:firstMeeting];
//        } else {
//            // meetings are sorted by start date, only the last array needs to be checked
//            NSMutableArray* recentlyParsedMeetings = [mutableParsedMeetings lastObject];
//            Meeting* recentlyParsedMeeting = [recentlyParsedMeetings lastObject];
//
//            switch ([recentlyParsedMeeting compareWeekday:meeting]) {
//                case NSOrderedSame:
//                    [recentlyParsedMeetings addObject:meeting];
//                    break;
//                    
//                case NSOrderedAscending: {
//                    NSMutableArray* parsedMeetings = [@[meeting] mutableCopy];
//                    [mutableParsedMeetings addObject:parsedMeetings];
//                    break;
//                }
//                    
//                case NSOrderedDescending: {
//                    DLog(@"<DEBUG> Error with meeting sorting");
//                    break;
//                }
//            }
//        }
    }
    
    return mutableParsedMeetings;
}

- (NSArray*)filteredMeetingsForSelectedWeekday:(NSInteger)weekday
{
    if (weekday == SHOW_ALL_WEEKDAYS_INDEX) {
        return [self.meetings copy];
    } else {
        NSArray* filteredMeetings = @[self.meetings[weekday]];
        return filteredMeetings;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_VIEW_HEIGHT;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    NSArray* weekdayMeetings = self.meetings[section];
//    Meeting* meeting = [weekdayMeetings firstObject];
//    NSInteger weekdayIndex = [meeting.startDate weekday] - 1;
    
    CGRect headerViewFrame = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT);
    
    AAMeetingSectionDividerView* headerView = [[AAMeetingSectionDividerView alloc] initWithFrame:headerViewFrame];
    
    if (self.weekdaySegmentedControl.selectedSegmentIndex == ALL_WEEKDAYS_SEGMENT_INDEX) {
        headerView.titleLabel.text = [NSCalendar autoupdatingCurrentCalendar].weekdaySymbols[section];
    } else {
        headerView.titleLabel.text = [NSCalendar autoupdatingCurrentCalendar].weekdaySymbols[self.weekdaySegmentedControl.selectedSegmentIndex - 1];
    }

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
    
    Meeting* meeting = [self meetingForIndexPath:indexPath];
    cell.meeting = meeting;
    cell.titleLabel.text = meeting.title;
    cell.addressLabel.text = meeting.location;
    
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
    NSMutableArray* sectionMeetings = self.meetings[indexPath.section];
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
        [[AAUserDataManager sharedManager] removeMeeting:meeting];
        
        [self deleteMeetingAtIndexPath:indexPath];
        self.filteredMeetings = [self filteredMeetingsForSelectedWeekday:self.weekdaySegmentedControl.selectedSegmentIndex - 1];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        if ([segue.destinationViewController isKindOfClass:[AAEditMeetingViewController class]]) {
            AAEditMeetingViewController* aaemvc = (AAEditMeetingViewController*)segue.destinationViewController;
            aaemvc.delegate = self;
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
