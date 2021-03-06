//
//  AAEditMeetingViewController.m
//  Steps
//
//  Created by Tom on 11/29/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserContactsManager.h"
#import "AAUserMeetingsManager.h"
#import "AAUserSettingsManager.h"

#import "Location.h"

#import "AAEditMeetingViewController.h"
#import "AASelectMeetingPropertyViewController.h"

#import "AAEditMeetingTextInputCell.h"
#import "AAEditMeetingWeekdayCell.h"
#import "AAEditMeetingDurationCell.h"
#import "AAEditMeetingStartTimeCell.h"
#import "AAEditMeetingProgramTypeCell.h"
#import "AAEditMeetingFormatCell.h"
#import "AAEditMeetingOpenCell.h"
#import "AAMeetingProgramDecorationView.h"
#import "AAMeetingSectionDividerView.h"

#import "NSDate+AAAdditions.h"
#import "NSDateFormatter+AAAdditions.h"
#import "UIColor+AAAdditions.h"
#import "UIFont+AAAdditions.h"


@interface AAEditMeetingViewController() <AAEditMeetingPickerCellDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightToolbarItem; // add/edit

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UITextField* titleTextField;
@property (weak, nonatomic) UITextField* locationTextField;

@property (weak, nonatomic) AAMeetingProgramDecorationView* programDecorationView;

@property (strong, nonatomic) NSIndexPath* selectedIndexPath;

@end

@implementation AAEditMeetingViewController

#pragma mark - Lifecycle and Properties

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // save changes in case user decides to undo their edits
    [[AAUserMeetingsManager sharedManager] synchronize];
    
    [self setup];
}

- (void)setup
{
    // setup the navigation bar before creating a new meeting object
    // to ensure that the navigation bar is set up for a new meeting
    [self setupNavigationBar];
    [self setupMeetingValues];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupMeetingValues
{
    if (self.meeting) {
        self.navigationBarTitle.title = NSLocalizedString(@"Edit Meeting", @"Edit the selected meeting's details");
    } else {
        self.navigationBarTitle.title = NSLocalizedString(@"New Meeting", @"Create a new meeting");
        self.selectedMeetingProperty = MeetingDescriptorAttributes.title;
        self.meeting = [[AAUserMeetingsManager sharedManager] createMeeting];
        self.meeting.location = [[AAUserMeetingsManager sharedManager] createLocation];
    }
}

- (void)setupNavigationBar
{
    if (self.meeting) {
        self.rightToolbarItem.title = NSLocalizedString(@"Done", @"Done editing the meeting");
    } else {
        self.rightToolbarItem.title = NSLocalizedString(@"Add", @"Add the meeting to the calendar");
        self.rightToolbarItem.enabled = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self assignFirstResponderToSelectedProperty];
}


#pragma mark - UI Events

#define ANIMATION_DURATION  0.2f

- (IBAction)leftToolbarButtonTapped:(UIBarButtonItem *)sender
{
    // user canceled, undo any changes to the meeting
    [[AAUserMeetingsManager sharedManager] rollback];
    [self.delegate viewControllerDidCancel:self];
}

- (IBAction)rightToolbarButtonTapped:(UIBarButtonItem *)sender
{
    self.meeting.title = self.titleTextField.text;
    self.meeting.location.title = self.locationTextField.text;
    
    [self.delegate viewControllerDidFinish:self];
}

- (void)openMeetingSwitchTapped:(UISwitch*)sender
{
    self.meeting.isOpen = @(sender.isOn);
    self.programDecorationView.isOpen = sender.isOn;
    [self.view endEditing:YES];
}

- (void)updateWeekdayWithCell:(AAEditMeetingWeekdayCell*)cell
{
    self.meeting.startDate = [NSDate dateByConvertingDate:self.meeting.startDate toWeekday:cell.selectedWeekday];
    cell.descriptionLabel.text = [cell currentWeekdaySymbol];
}

- (void)updateStartTimeWithCell:(AAEditMeetingStartTimeCell*)cell
{
    self.meeting.startDate = [NSDate dateByCombiningDayOfDate:self.meeting.startDate withTimeOfDate:cell.datePicker.date];
    cell.descriptionLabel.text = [[[NSDateFormatter alloc] init] stepsTimeStringFromDate:self.meeting.startDate];
}

- (void)updateDurationWithCell:(AAEditMeetingDurationCell*)cell
{
    self.meeting.duration = cell.durationPicker.date;
    cell.descriptionLabel.text = [AAMeetingDurationPickerView localizedDurationStringForDate:self.meeting.duration];
}


#pragma mark - Picker Cell Delegate

- (void)pickerCellValueChanged:(AAEditMeetingPickerCell *)cell
{
    switch (cell.type) {
        case AAEditMeetingPickerCellTypeWeekday:
            [self updateWeekdayWithCell:(AAEditMeetingWeekdayCell*)cell];
            break;
            
        case AAEditMeetingPickerCellTypeStartTime:
            [self updateStartTimeWithCell:(AAEditMeetingStartTimeCell*)cell];
            break;
            
        case AAEditMeetingPickerCellTypeDuration:
            [self updateDurationWithCell:(AAEditMeetingDurationCell*)cell];
            break;
            
        default:
            break;
    }
}

#pragma mark - Tableview Delegate and DataSource

#define TEXT_INPUT_CELL_REUSE_ID        @"TextInputCell"
#define WEEKDAY_PICKER_CELL_REUSE_ID    @"WeekdayInputCell"
#define START_TIME_PICKER_CELL_REUSE_ID @"StartTimeCell"
#define DURATION_PICKER_CELL_REUSE_ID   @"DurationInputCell"
#define FORMAT_CELL_REUSE_ID            @"MeetingFormatCell"
#define OPEN_MEETING_CELL_REUSE_ID      @"MeetingOpenCell"
#define PROGRAM_TYPE_CELL_REUSE_ID      @"MeetingProgramCell"

#define TITLE_LOCATION_SECTION          0
#define TITLE_ROW_INDEX             0
#define LOCATION_ROW_INDEX          1

#define DATE_TIME_SECTION               1
#define WEEKDAY_ROW                 0
#define START_TIME_ROW              1
#define DURATION_ROW                2

#define MEETING_TYPE_SECTION            2
#define OPEN_MEETING_ROW            0
#define PROGRAM_ROW                 1
#define FORMAT_ROW                  2


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case TITLE_LOCATION_SECTION:
            return 2;
            
        case DATE_TIME_SECTION:
            return 3;
            
        case MEETING_TYPE_SECTION:
            return 3;
            
        default:
            return 0;
    }
}

#define TEXT_CELL_HEIGHT    44.0f
#define PICKER_CELL_HEIGHT  216.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == DATE_TIME_SECTION && [indexPath isEqual:self.selectedIndexPath]) {
        return TEXT_CELL_HEIGHT + PICKER_CELL_HEIGHT;
    } else {
        return TEXT_CELL_HEIGHT;
    }
}

#pragma mark Cell Creation

- (AASeparatorTableViewCell*)separatorCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case TITLE_LOCATION_SECTION:
            return [self textInputCellForIndexPath:indexPath];
            
        case DATE_TIME_SECTION:
            return [self dateTimeCellForIndexPath:indexPath];
            
        case MEETING_TYPE_SECTION:
            return [self meetingTypeCellForIndexPath:indexPath];
            
        default:
            return nil;
    }
}

#pragma mark Title/Location Cells


#define TITLE_INPUT_FIELD_TAG       100
#define LOCATION_INPUT_FIELD_TAG    101

- (AASeparatorTableViewCell*)textInputCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingTextInputCell* cell = (AAEditMeetingTextInputCell*)[self.tableView dequeueReusableCellWithIdentifier:TEXT_INPUT_CELL_REUSE_ID];
    
    if (indexPath.row == TITLE_ROW_INDEX) {
        cell.textField.text = self.meeting.title;
        cell.textField.placeholder = NSLocalizedString(@"Title", @"Meeting Title");
        cell.textField.tag = TITLE_INPUT_FIELD_TAG;
        self.titleTextField = cell.textField;
    } else {
        cell.textField.text = self.meeting.location.title;
        cell.textField.placeholder = NSLocalizedString(@"Location", @"Meeting Location");
        cell.textField.tag = LOCATION_INPUT_FIELD_TAG;
        self.locationTextField = cell.textField;
    }
    
    cell.textField.delegate = self;
    
    return cell;
}

#pragma mark Date/Time Cells


- (AASeparatorTableViewCell*)dateTimeCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingPickerCell* cell = nil;
    switch (indexPath.row) {
        case WEEKDAY_ROW:
            cell = [self weekdayCellForIndexPath:indexPath];
            break;
            
        case START_TIME_ROW:
            cell = [self startTimeCellForIndexPath:indexPath];
            break;
            
        case DURATION_ROW:
            cell = [self durationCellForIndexPath:indexPath];
            break;
            
        default:
            break;
    }
    
    cell.delegate = self;
    
    if ([indexPath isEqual:self.selectedIndexPath]) {
        cell.pickerHidden = NO;
    } else {
        cell.pickerHidden = YES;
    }
    
    return cell;
}

- (AAEditMeetingWeekdayCell*)weekdayCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingWeekdayCell* cell = [self.tableView dequeueReusableCellWithIdentifier:WEEKDAY_PICKER_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingWeekdayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WEEKDAY_PICKER_CELL_REUSE_ID];
    }
    
    cell.titleLabel.text = NSLocalizedString(@"Weekday", @"Day of the week the meeting occurs");
    cell.descriptionLabel.text = [cell weekdaySymbolForWeekday:(AADateWeekday)self.meeting.startDate.weekday];
    cell.selectedWeekday = self.meeting.startDate.weekday;
    
    return cell;
}

- (AAEditMeetingPickerCell*)startTimeCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingStartTimeCell* cell = [self.tableView dequeueReusableCellWithIdentifier:START_TIME_PICKER_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingStartTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:START_TIME_PICKER_CELL_REUSE_ID];
    }
    
    cell.titleLabel.text = NSLocalizedString(@"Starts", @"The meeting starts at the following time");
    cell.descriptionLabel.text = [[[NSDateFormatter alloc] init] stepsTimeStringFromDate:self.meeting.startDate];
    cell.datePicker.date = self.meeting.startDate;
    
    return cell;
}

- (AAEditMeetingPickerCell*)durationCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingDurationCell* cell = [self.tableView dequeueReusableCellWithIdentifier:DURATION_PICKER_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingDurationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DURATION_PICKER_CELL_REUSE_ID];
    }
    
    cell.titleLabel.text = NSLocalizedString(@"Duration", @"The length of the meeting in hours and minutes");
    cell.descriptionLabel.text = [AAMeetingDurationPickerView localizedDurationStringForDate:self.meeting.duration];
    cell.durationPicker.date = self.meeting.duration;
    
    return cell;
}

#pragma mark Meeting Type Cells

- (AASeparatorTableViewCell*)meetingTypeCellForIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case OPEN_MEETING_ROW:
            return [self openMeetingCellForIndexPath:indexPath];
        
        case FORMAT_ROW:
            return [self formatCellForIndexPath:indexPath];
            
        case PROGRAM_ROW:
            return [self programCellForIndexPath:indexPath];
            
        default:
            return nil;
    }
}

- (AAEditMeetingOpenCell*)openMeetingCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingOpenCell* cell = (AAEditMeetingOpenCell*)[self.tableView dequeueReusableCellWithIdentifier:OPEN_MEETING_CELL_REUSE_ID];
    
    [cell.openMeetingSwitch setOn:self.meeting.isOpenValue animated:YES];
    [cell.openMeetingSwitch addTarget:self action:@selector(openMeetingSwitchTapped:) forControlEvents:UIControlEventValueChanged];
    

    
    return cell;
}

- (AAEditMeetingFormatCell*)formatCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingFormatCell* cell = (AAEditMeetingFormatCell*)[self.tableView dequeueReusableCellWithIdentifier:FORMAT_CELL_REUSE_ID];
    
    cell.formatLabel.format = [self.meeting.formats anyObject];
    cell.formatLabel.textAlignment = AATextAlignmentRight;
    cell.formatLabel.decorationAlignment = AADecorationAlignmentLeft;
    
    return cell;
}

- (AAEditMeetingProgramTypeCell*)programCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingProgramTypeCell* cell = (AAEditMeetingProgramTypeCell*)[self.tableView dequeueReusableCellWithIdentifier:PROGRAM_TYPE_CELL_REUSE_ID];
    
    cell.programDecorationView.program = self.meeting.program;
    cell.programDecorationView.isOpen = self.meeting.isOpenValue;
    self.programDecorationView = cell.programDecorationView;
    
    return cell;
}

#pragma mark Cell Interaction

- (void)assignFirstResponderToSelectedProperty
{
    if (self.selectedMeetingProperty) {
        if ([self.selectedMeetingProperty isEqualToString:EventAttributes.title]) {
            [self.titleTextField becomeFirstResponder];
        } else if ([self.selectedMeetingProperty isEqualToString:EventAttributes.startDate]) {
            self.selectedIndexPath = [NSIndexPath indexPathForRow:START_TIME_ROW inSection:DATE_TIME_SECTION];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:DATE_TIME_SECTION] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if ([self.selectedMeetingProperty isEqualToString:MeetingRelationships.location]) {
            [self.locationTextField becomeFirstResponder];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateSelectedCellIndexPath:indexPath];
    
    if (indexPath.section != TITLE_LOCATION_SECTION) {
        [self.view endEditing:YES];
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)updateSelectedCellIndexPath:(NSIndexPath*)indexPath
{
    // Hide current picker if visible
    UITableViewCell* oldSelectedCell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    if ([oldSelectedCell isKindOfClass:[AAEditMeetingPickerCell class]]) {
        AAEditMeetingPickerCell* pickerCell = (AAEditMeetingPickerCell*)oldSelectedCell;
        pickerCell.pickerHidden = YES;
    }
    
    if ([self.selectedIndexPath isEqual:indexPath]) {
        // Selected cell should be deselected
        self.selectedIndexPath = nil;
    } else {
        // Show picker if a picker cell was tapped
        UITableViewCell* selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        if ([selectedCell isKindOfClass:[AAEditMeetingPickerCell class]]) {
            AAEditMeetingPickerCell* pickerCell = (AAEditMeetingPickerCell*)selectedCell;
            pickerCell.pickerHidden = NO;
        }
        
        self.selectedIndexPath = indexPath;
    }
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // dismiss any pickers that are visible
    // by setting selected cell index path to nil
    // and reloading cell heights
    [self updateSelectedCellIndexPath:nil];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == TITLE_INPUT_FIELD_TAG) {
        self.meeting.title = result;
        
        // Before saving is allowed a title must be provided for the meeting
        if ([[result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) { // no title entered
            self.rightToolbarItem.enabled = NO;
        } else { // title has been entered
            self.rightToolbarItem.enabled = YES;
        }
    } else {
        self.meeting.location.title = result;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField.tag == TITLE_INPUT_FIELD_TAG) {
        self.rightToolbarItem.enabled = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == TITLE_INPUT_FIELD_TAG) {
        [self.titleTextField resignFirstResponder];
        [self.locationTextField becomeFirstResponder];
    } else {
        [self.locationTextField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[AASelectMeetingPropertyViewController class]]) {
        AASelectMeetingPropertyViewController* aaempvc = (AASelectMeetingPropertyViewController*)segue.destinationViewController;
        
        aaempvc.meeting = self.meeting;
    }
}

@end
