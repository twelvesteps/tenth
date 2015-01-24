//
//  AAMeetingViewController.m
//  Steps
//
//  Created by Tom on 11/17/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingViewController.h"
#import "AAEditMeetingViewController.h"

#import "AAMeetingDisplayTitleCell.h"
#import "AAMeetingDisplayLocationCell.h"
#import "AAMeetingDisplayDateCell.h"

#import "AAEditMeetingOpenCell.h"
#import "AAEditMeetingProgramTypeCell.h"
#import "AAEditMeetingFormatCell.h"

#import "AAUserMeetingsManager.h"

#import "UIColor+AAAdditions.h"

@interface AAMeetingViewController () <AAEditMeetingViewControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editDoneButton; // edit/done button

@property (weak, nonatomic) IBOutlet UIButton *deleteMeetingButton;
@property (weak, nonatomic) IBOutlet UIView *deleteMeetingButtonContainer;
@property (weak, nonatomic) UIView* deleteMeetingButtonContainerSeparatorView;

@property (weak, nonatomic) AAMeetingProgramDecorationView* programDecorationView;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[AAUserMeetingsManager sharedManager] synchronize];
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

- (void)openMeetingSwitchTapped:(UISwitch*)sender
{
    self.meeting.isOpenValue = sender.on;
    self.programDecorationView.isOpen = sender.on;
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

#define MEETING_TITLE_CELL_REUSE_ID     @"MeetingTitleCell"
#define MEETING_DATE_CELL_REUSE_ID      @"MeetingTimeCell"
#define MEETING_LOCATION_CELL_REUSE_ID  @"MeetingLocationCell"

#define MEETING_OPEN_CELL_REUSE_ID      @"MeetingOpenCell"
#define MEETING_PROGRAM_CELL_REUSE_ID   @"MeetingProgramCell"
#define MEETING_FORMAT_CELL_REUSE_ID    @"MeetingFormatCell"

// Section contains meeting title, location, and start date
#define EVENT_INFO_SECTION              0
#define MEETING_TITLE_ROW_INDEX             0
#define MEETING_START_DATE_ROW_INDEX        1
#define MEETING_LOCATION_ROW_INDEX          2
// Section contains openness, format, and program
#define MEETING_DESCRIPTION_SECTION     1
#define MEETING_OPEN_ROW_INDEX              0
#define MEETING_PROGRAM_ROW_INDEX           1
#define MEETING_FORMAT_ROW_INDEX            2

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case EVENT_INFO_SECTION:
            return 3;
            
        case MEETING_DESCRIPTION_SECTION:
            return 3;
            
        default:
            DLog(@"<DEBUG> Checking for section outside expected bounds, section #%d", (int)section);
            return 0;
    }
}

- (AASeparatorTableViewCell*)separatorCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case EVENT_INFO_SECTION:
            return [self eventInfoCellForIndexPath:indexPath];
            
        case MEETING_DESCRIPTION_SECTION:
            return [self meetingDescriptionCellForIndexPath:indexPath];
            
        default:
            DLog(@"<DEBUG> Checking for section outside expected bounds, section #%d", (int)indexPath.section);
            return nil;
    }
}

- (AASeparatorTableViewCell*)eventInfoCellForIndexPath:(NSIndexPath*)indexPath
{
    switch ((indexPath.row)) {
        case MEETING_TITLE_ROW_INDEX:
            return [self meetingTitleCell];
            
        case MEETING_LOCATION_ROW_INDEX:
            return [self meetingLocationCell];
            
        case MEETING_START_DATE_ROW_INDEX:
            return [self meetingStartDateCell];
            
        default:
            DLog(@"<DEBUG> Checking for row oustide expected bounds, Index Path %@", indexPath);
            return nil;
    }
}

- (AAMeetingDisplayTitleCell*)meetingTitleCell
{
    AAMeetingDisplayTitleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:MEETING_TITLE_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAMeetingDisplayTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MEETING_TITLE_CELL_REUSE_ID];
    }
    
    cell.titleLabel.text = self.meeting.title;
    
    return cell;
}

- (AAMeetingDisplayDateCell*)meetingStartDateCell
{
    AAMeetingDisplayDateCell* cell = [self.tableView dequeueReusableCellWithIdentifier:MEETING_DATE_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAMeetingDisplayDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MEETING_DATE_CELL_REUSE_ID];
    }
    
    cell.dateLabel.text = [self meetingStartDateText];
    
    return cell;
}

- (NSString*)meetingStartDateText
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    
    return [formatter stringFromDate:self.meeting.startDate];
}

- (AAMeetingDisplayLocationCell*)meetingLocationCell
{
    AAMeetingDisplayLocationCell* cell = [self.tableView dequeueReusableCellWithIdentifier:MEETING_LOCATION_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAMeetingDisplayLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MEETING_LOCATION_CELL_REUSE_ID];
    }
    
    cell.locationLabel.text = self.meeting.location.title;
    
    return cell;
}


- (AASeparatorTableViewCell*)meetingDescriptionCellForIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case MEETING_OPEN_ROW_INDEX:
            return [self meetingOpenCell];

        case MEETING_PROGRAM_ROW_INDEX:
            return [self meetingProgramCell];
            
        case MEETING_FORMAT_ROW_INDEX:
            return [self meetingFormatCell];
            
        default:
            DLog(@"<DEBUG> Checking for row oustide expected bounds, Index Path %@", indexPath);
            return nil;
    }
}

- (AAEditMeetingOpenCell*)meetingOpenCell
{
    AAEditMeetingOpenCell* cell = [self.tableView dequeueReusableCellWithIdentifier:MEETING_OPEN_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingOpenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MEETING_OPEN_CELL_REUSE_ID];
    }
    
    cell.openMeetingSwitch.on = self.meeting.isOpenValue;
    [cell.openMeetingSwitch addTarget:self action:@selector(openMeetingSwitchTapped:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (AAEditMeetingProgramTypeCell*)meetingProgramCell
{
    AAEditMeetingProgramTypeCell* cell = [self.tableView dequeueReusableCellWithIdentifier:MEETING_PROGRAM_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingProgramTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MEETING_PROGRAM_CELL_REUSE_ID];
    }
    
    cell.programDecorationView.program = self.meeting.program;
    cell.programDecorationView.isOpen = self.meeting.isOpenValue;
    self.programDecorationView = cell.programDecorationView;
    
    return cell;
}

- (AAEditMeetingFormatCell*)meetingFormatCell
{
    AAEditMeetingFormatCell* cell = [self.tableView dequeueReusableCellWithIdentifier:MEETING_FORMAT_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingFormatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MEETING_FORMAT_CELL_REUSE_ID];
    }
    
    cell.formatLabel.format = [self.meeting.formats anyObject];
    
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
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Navigation

#define EDIT_MEETING_SEGUE_ID   @"setMeeting"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navController = (UINavigationController*)segue.destinationViewController;
        if ([navController.topViewController isKindOfClass:[AAEditMeetingViewController class]]) {
            AAEditMeetingViewController* aaemvc = (AAEditMeetingViewController*)navController.topViewController;
 
            // setting an unrecognized value will have no effect
            aaemvc.selectedMeetingProperty = segue.identifier;
            aaemvc.meeting = self.meeting;
            aaemvc.delegate = self;
        }
    }
}

@end
