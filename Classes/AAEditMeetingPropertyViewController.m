//
//  AAEditMeetingPropertyViewController.m
//  Steps
//
//  Created by Tom on 12/30/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingPropertyViewController.h"
@interface AAEditMeetingPropertyViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AAEditMeetingPropertyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.meetingPropertyDelegate.tableView = self.tableView;
}

- (void)setMeetingPropertyDelegate:(AAEditMeetingPropertyTableViewDelegate *)meetingPropertyDelegate
{
    _meetingPropertyDelegate = meetingPropertyDelegate;
    
    meetingPropertyDelegate.tableView = self.tableView;
}

@end
