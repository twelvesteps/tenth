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

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@end

@implementation AAMeetingViewController

#pragma mark - Lifecycle and Properties

#define MEETING_INFO_CELL_REUSE_IDENTIFIER  @"MeetingInfoCell"

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UI Events


#pragma mark - UITableview Delegate and Datasource


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
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:MEETING_INFO_CELL_REUSE_IDENTIFIER];
    
    return cell;
    
    /*
    switch (indexPath.section) {
            
        default:
            return nil;
    }
     */

}

@end
