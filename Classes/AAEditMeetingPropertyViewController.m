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

#pragma mark - UITableView Delegate and Datasource

// the following calls are forwarded to the meetingPropertyDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.meetingPropertyDelegate numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.meetingPropertyDelegate tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.meetingPropertyDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.meetingPropertyDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}


@end
