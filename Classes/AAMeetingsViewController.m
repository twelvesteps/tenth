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

@interface AAMeetingsViewController () <AAEditMeetingViewControllerDelegate>

@property (strong, nonatomic) NSArray* meetings; // an array of arrays, sorted by start date


@end

@implementation AAMeetingsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateMeetings];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateMeetings];
    [self.tableView reloadData];
}

- (void)updateMeetings
{
    NSArray* allMeetings = [[AAUserDataManager sharedManager] fetchMeetings];
    self.meetings = [self parseMeetingsByStartDate:allMeetings];
}


#pragma mark - Meeting Parsing

- (NSArray*)parseMeetingsByStartDate:(NSArray*)meetings
{
    NSMutableArray* mutableParsedMeetings = [[NSMutableArray alloc] init];
    for (Meeting* meeting in meetings) {
        if (mutableParsedMeetings.count == 0) { // No meetings have been parsed, add current meeting
            NSMutableArray* firstMeeting = [@[meeting] mutableCopy];
            [mutableParsedMeetings addObject:firstMeeting];
        } else {
            // meetings are sorted by start date, only the last array needs to be checked
            NSMutableArray* recentlyParsedMeetings = [mutableParsedMeetings lastObject];
            Meeting* recentlyParsedMeeting = [recentlyParsedMeetings lastObject];

            switch ([recentlyParsedMeeting.startDate compare:meeting.startDate]) {
                case NSOrderedSame:
                    [recentlyParsedMeetings addObject:meeting];
                    break;
                    
                case NSOrderedAscending: {
                    NSMutableArray* parsedMeetings = [@[meeting] mutableCopy];
                    [mutableParsedMeetings addObject:parsedMeetings];
                    break;
                }
                    
                case NSOrderedDescending: {
                    DLog(@"<DEBUG> Error with meeting sorting");
                    break;
                }
            }
        }
    }
    
    return [mutableParsedMeetings copy];
}


#pragma mark - UI Events



#pragma mark - UITableView Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.meetings.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* sectionMeetings = self.meetings[section];
    return sectionMeetings.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAMeetingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingCell"];
    
    Meeting* meeting = [self meetingForIndexPath:indexPath];
    cell.meeting = meeting;
    cell.titleLabel.text = meeting.title;
    cell.addressLabel.text = meeting.location;
    
    return cell;
}

- (Meeting*)meetingForIndexPath:(NSIndexPath*)indexPath
{
    NSArray* sectionMeetings = self.meetings[indexPath.section];
    return sectionMeetings[indexPath.row];
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
        [self updateMeetings];
        DLog(@"Section: %d, Row: %d", (int)indexPath.section, (int)indexPath.row);
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
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
