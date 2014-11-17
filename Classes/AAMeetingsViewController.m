//
//  AAMeetingsViewController.m
//  Steps
//
//  Created by Tom on 11/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingsViewController.h"
#import "AAUserDataManager.h"
#import "AAMeetingTableViewCell.h"

@interface AAMeetingsViewController ()

@property (strong, nonatomic) NSArray* meetings; // an array of arrays, sorted by start date

@end

@implementation AAMeetingsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
                    NSMutableArray* parsedMeetings = [[NSMutableArray alloc] init];
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

- (IBAction)rightToolbarItemTapped:(UIBarButtonItem *)sender
{
    Meeting* meeting = [[AAUserDataManager sharedManager] createMeeting];
    meeting.title = @"New Meeting";
    meeting.startDate = [NSDate date];
    meeting.address = @"Here";
    
    [self.tableView reloadData];
}


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
    cell.titleLabel.text = meeting.title;
    cell.addressLabel.text = meeting.address;
    cell.notesLabel.text = meeting.types;
    
    return cell;
}

- (Meeting*)meetingForIndexPath:(NSIndexPath*)indexPath
{
    NSArray* sectionMeetings = self.meetings[indexPath.section];
    return sectionMeetings[indexPath.row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
