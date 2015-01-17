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

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.meetingPropertyDelegate.isEditable) {
        [self loadEditButton];
    }
}

- (void)loadEditButton
{
    [self loadBarButtonSystemItem:UIBarButtonSystemItemEdit action:@selector(editButtonTapped:)];
}

- (void)loadDoneButton
{
    [self loadBarButtonSystemItem:UIBarButtonSystemItemDone action:@selector(doneButtonTapped:)];
}

- (void)loadBarButtonSystemItem:(UIBarButtonSystemItem)item action:(SEL)action
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:action];
}

#pragma mark - UI Events

- (void)editButtonTapped:(UIBarButtonItem*)sender
{
    [self loadDoneButton];
    [self.tableView setEditing:YES animated:YES];
    [self.tableView reloadData];
}

- (void)doneButtonTapped:(UIBarButtonItem*)sender
{
    [self loadEditButton];
    [self.tableView setEditing:NO animated:YES];
    [self.tableView reloadData];
}

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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.meetingPropertyDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.meetingPropertyDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
}


@end
