//
//  AAMeetingViewController.m
//  Steps
//
//  Created by Tom on 11/17/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingViewController.h"

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
#define DAY_OF_WEEK_SECTION     2
#define TIME_OF_DAY_SECTION     3

#define NAME_REUSE_ID       @"MeetingNameCell"
#define LOCATION_REUSE_ID   @"MeetingLocationCell"
#define WEEKDAY_REUSE_ID    @"MeetingDayOfWeekCell"
#define TIME_REUSE_ID       @"MeetingTimeOfDayCell"

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


@end
