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

#import "AAUserMeetingsManager.h"

#import "UIColor+AAAdditions.h"

@interface AAMeetingViewController () <AAEditMeetingViewControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editDoneButton; // edit/done button

@property (weak, nonatomic) IBOutlet UIButton *deleteMeetingButton;
@property (weak, nonatomic) IBOutlet UIView *deleteMeetingButtonContainer;
@property (weak, nonatomic) UIView* deleteMeetingButtonContainerSeparatorView;

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@end

@implementation AAMeetingViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup
{
    [self setupDeleteMeetingButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupDeleteMeetingButton
{
    [self.deleteMeetingButton setTitleColor:[UIColor stepsRedColor] forState:UIControlStateNormal];
    
    UIView* separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = [UIColor stepsTableViewCellSeparatorColor];
    [self.deleteMeetingButtonContainer addSubview:separatorView];
    self.deleteMeetingButtonContainerSeparatorView = separatorView;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self layoutDeleteMeetingButtonSeparatorView];
}

- (void)layoutDeleteMeetingButtonSeparatorView
{
    CGRect separatorViewFrame = CGRectMake(self.deleteMeetingButtonContainer.bounds.origin.x,
                                           self.deleteMeetingButtonContainer.bounds.origin.y + SEPARATOR_HEIGHT,
                                           self.deleteMeetingButtonContainer.bounds.size.width,
                                           SEPARATOR_HEIGHT);
    
    self.deleteMeetingButtonContainerSeparatorView.frame = separatorViewFrame;
}

#pragma mark - UI Events

#define DELETE_MEETING_ACTION_SHEET_TITLE  NSLocalizedString(@"Delete the meeting? This action cannot be undone", nil)

- (IBAction)deleteMeetingButtonTapped:(UIButton *)sender
{
    [self presentDeleteMeetingActionSheet];
}

- (void)presentDeleteMeetingActionSheet
{
    UIActionSheet* deleteMeetingActionSheet = [[UIActionSheet alloc] initWithTitle:DELETE_MEETING_ACTION_SHEET_TITLE delegate:self
                                                                 cancelButtonTitle:NSLocalizedString(@"Cancel", "Cancel meeting deletion")
                                                            destructiveButtonTitle:NSLocalizedString(@"Delete", @"Delete the meeting")
                                                                 otherButtonTitles:nil];
    
    [deleteMeetingActionSheet showInView:self.view];
}


#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [[AAUserMeetingsManager sharedManager] removeMeeting:self.meeting];
        UINavigationController* controller = self.navigationController;
        [controller popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableview Delegate and Datasource

#define MEETING_INFO_CELL_REUSE_ID      @"MeetingInfoCell"

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAMeetingInfoTableViewCell* cell = [self meetingInfoCellForIndexPath:indexPath];
    return [AAMeetingInfoTableViewCell heightForCell:cell];
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MEETING_INFO_CELL_SECTION] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Navigation

#define EDIT_MEETING_SEGUE_ID   @"setMeeting"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:EDIT_MEETING_SEGUE_ID]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navController = (UINavigationController*)segue.destinationViewController;
            if ([navController.topViewController isKindOfClass:[AAEditMeetingViewController class]]) {
                AAEditMeetingViewController* aaemvc = (AAEditMeetingViewController*)navController.topViewController;
                
                aaemvc.meeting = self.meeting;
                aaemvc.delegate = self;
            }
        }
    }
}

@end
