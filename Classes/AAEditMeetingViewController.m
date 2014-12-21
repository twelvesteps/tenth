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

#import "AAEditMeetingViewController.h"
#import "AAEditMeetingProgramViewController.h"

#import "AAEditMeetingTextInputCell.h"
#import "AAEditMeetingWeekdayCell.h"
#import "AAEditMeetingDurationCell.h"
#import "AAEditMeetingStartTimeCell.h"
#import "AAEditMeetingProgramTypeCell.h"
#import "AAEditMeetingFormatPickerCell.h"
#import "AAEditMeetingOpenCell.h"
#import "AAMeetingFellowshipIcon.h"
#import "AAMeetingSectionDividerView.h"

#import "MeetingDescriptor+Localization.h"
#import "Meeting+AAAdditions.h"
#import "NSDate+AAAdditions.h"
#import "UIColor+AAAdditions.h"
#import "UIFont+AAAdditions.h"


@interface AAEditMeetingViewController() <AAEditMeetingPickerCellDelegate, AAEditMeetingProgramViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightToolbarItem; // add/edit

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UITextField* titleTextField;
@property (weak, nonatomic) UITextField* locationTextField;

@property (weak, nonatomic) AAMeetingFellowshipIcon* fellowshipIcon;

@property (nonatomic) BOOL shouldActivateTitleField;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;

@property (nonatomic) MeetingFormat* format;
@property (nonatomic) MeetingProgram* program;
@property (nonatomic) NSInteger weekday;
@property (strong, nonatomic) NSDate* startTime;
@property (strong, nonatomic) NSDate* duration;

@property (nonatomic) BOOL openMeeting;

@end

@implementation AAEditMeetingViewController

#pragma mark - Lifecycle and Properties

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup
{
    [self setupMeetingValues];
    [self setupNavigationBar];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupMeetingValues
{
    if (self.meeting) {
        self.navigationBarTitle.title = NSLocalizedString(@"Edit Meeting", @"Edit the selected meeting's details");
        self.weekday = [self.meeting.startDate weekday];
        self.startTime = self.meeting.startDate;
        self.duration = self.meeting.duration;
        self.openMeeting = self.meeting.openMeeting;
        self.format = [self.meeting.formats anyObject];
        self.program = [self.meeting.programs anyObject];
        self.shouldActivateTitleField = NO;
    } else {
        self.navigationBarTitle.title = NSLocalizedString(@"New Meeting", @"Create a new meeting");
        self.weekday = [[NSDate date] weekday];
        self.startTime = [[NSDate date] nearestHalfHour];
        self.duration = [NSDate oneHour];
        self.openMeeting = NO;
        self.format = nil;
        self.program = [[AAUserSettingsManager sharedManager] defaultMeetingProgram];
        self.shouldActivateTitleField = YES;
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
    if (self.shouldActivateTitleField) {
        [self.titleTextField becomeFirstResponder];
        self.shouldActivateTitleField = NO;
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - Meeting

- (void)syncMeeting
{
    if (!self.meeting) {
        self.meeting = [[AAUserMeetingsManager sharedManager] createMeeting];
    }

    self.meeting.title = self.titleTextField.text;
    self.meeting.location = self.locationTextField.text;
    
    self.meeting.startDate = [self dateByCombiningWeekdayAndStartTime];
    self.meeting.duration = self.duration;
    self.meeting.openMeeting = self.openMeeting;
    if (self.format) {
        self.meeting.formats = [NSSet setWithObjects:self.format, nil];
    } else {
        self.meeting.formats = nil;
    }
    
    if (self.program) {
        self.meeting.programs = [NSSet setWithObjects:self.program, nil];
    } else {
        self.meeting.programs = nil;
    }
}

- (NSDate*)dateByCombiningWeekdayAndStartTime
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dateComponents = [calendar components:(NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.startTime];
    dateComponents.second = 0;
    NSInteger weekdayOffset = self.weekday - dateComponents.weekday;
    
    return [calendar dateByAddingUnit:NSCalendarUnitDay value:weekdayOffset toDate:self.startTime options:0];
}


#pragma mark - UI Events

#define ANIMATION_DURATION  0.2f

- (IBAction)leftToolbarButtonTapped:(UIBarButtonItem *)sender
{
    [self.delegate viewControllerDidCancel:self];
}

- (IBAction)rightToolbarButtonTapped:(UIBarButtonItem *)sender
{
    [self syncMeeting];
    [self.delegate viewControllerDidFinish:self];
}

- (void)openMeetingSwitchTapped:(UISwitch*)sender
{
    self.openMeeting = sender.isOn;
    self.fellowshipIcon.isOpen = self.openMeeting;
    [self.view endEditing:YES];
}

- (void)updateWeekdayWithCell:(AAEditMeetingWeekdayCell*)cell
{
    self.weekday = cell.selectedWeekday;
    cell.descriptionLabel.text = [cell currentWeekdaySymbol];
}

- (void)updateStartTimeWithCell:(AAEditMeetingStartTimeCell*)cell
{
    self.startTime = cell.datePicker.date;
    cell.descriptionLabel.text = [self timeStringForDate:self.startTime];
}

- (void)updateDurationWithCell:(AAEditMeetingDurationCell*)cell
{
    self.duration = cell.durationPicker.date;
    cell.descriptionLabel.text = [AAMeetingDurationPickerView localizedDurationStringForDate:self.duration];
}

- (void)updateFormatWithCell:(AAEditMeetingFormatPickerCell*)cell
{
    self.format = cell.format;
    self.fellowshipIcon.format = self.format;
    
}

- (NSString*)timeStringForDate:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"j:mm" options:0 locale:[NSLocale autoupdatingCurrentLocale]];
    
    return [formatter stringFromDate:date];
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
            
        case AAEditMeetingPickerCellTypeMeetingFormat:
            [self updateFormatWithCell:(AAEditMeetingFormatPickerCell*)cell];
    }
}


#pragma mark - Program View Controller Delegate

- (void)programViewDidSelectProgramType:(AAEditMeetingProgramViewController *)controller
{
    self.program = controller.program;
    self.fellowshipIcon.program = self.program;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Tableview Delegate and DataSource

#define TEXT_INPUT_CELL_REUSE_ID        @"TextInputCell"
#define WEEKDAY_PICKER_CELL_REUSE_ID    @"WeekdayInputCell"
#define START_TIME_PICKER_CELL_REUSE_ID @"StartTimeCell"
#define DURATION_PICKER_CELL_REUSE_ID   @"DurationInputCell"
#define FORMAT_PICKER_CELL_REUSE_ID     @"FormatInputCell"
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
#define FORMAT_ROW                  1
#define PROGRAM_ROW                 2


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
    } else if (indexPath.section == MEETING_TYPE_SECTION &&
               indexPath.row == FORMAT_ROW && 
               [indexPath isEqual:self.selectedIndexPath]) {
        return TEXT_CELL_HEIGHT + PICKER_CELL_HEIGHT;
    } else {
        return TEXT_CELL_HEIGHT;
    }
}

#pragma mark Cell Creation

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (UITableViewCell*)textInputCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingTextInputCell* cell = (AAEditMeetingTextInputCell*)[self.tableView dequeueReusableCellWithIdentifier:TEXT_INPUT_CELL_REUSE_ID];
    
    if (indexPath.row == TITLE_ROW_INDEX) {
        cell.textField.text = self.meeting.title;
        cell.textField.placeholder = NSLocalizedString(@"Title", @"Meeting Title");
        cell.textField.tag = TITLE_INPUT_FIELD_TAG;
        self.titleTextField = cell.textField;
        cell.bottomSeparator = YES;
    } else {
        cell.textField.text = self.meeting.location;
        cell.textField.placeholder = NSLocalizedString(@"Location", @"Meeting Location");
        cell.textField.tag = LOCATION_INPUT_FIELD_TAG;
        self.locationTextField = cell.textField;
        cell.bottomSeparator = NO;
    }
    
    cell.textField.delegate = self;
    
    return cell;
}

#pragma mark Date/Time Cells


- (UITableViewCell*)dateTimeCellForIndexPath:(NSIndexPath*)indexPath
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
    cell.descriptionLabel.text = [NSCalendar autoupdatingCurrentCalendar].weekdaySymbols[self.weekday - 1];
    cell.selectedWeekday = self.weekday;
    cell.bottomSeparator = YES;
    
    return cell;
}

- (AAEditMeetingPickerCell*)startTimeCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingStartTimeCell* cell = [self.tableView dequeueReusableCellWithIdentifier:START_TIME_PICKER_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingStartTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:START_TIME_PICKER_CELL_REUSE_ID];
    }
    
    cell.titleLabel.text = NSLocalizedString(@"Starts", @"The meeting starts at the following time");
    cell.descriptionLabel.text = [self timeStringForDate:self.startTime];
    cell.datePicker.date = self.startTime;
    cell.bottomSeparator = YES;
    
    return cell;
}

- (AAEditMeetingPickerCell*)durationCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingDurationCell* cell = [self.tableView dequeueReusableCellWithIdentifier:DURATION_PICKER_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingDurationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DURATION_PICKER_CELL_REUSE_ID];
    }
    
    cell.titleLabel.text = NSLocalizedString(@"Duration", @"The length of the meeting in hours and minutes");
    cell.descriptionLabel.text = [AAMeetingDurationPickerView localizedDurationStringForDate:self.duration];
    cell.durationPicker.date = self.duration;
    cell.bottomSeparator = NO;
    
    return cell;
}

#pragma mark Meeting Type Cells

- (UITableViewCell*)meetingTypeCellForIndexPath:(NSIndexPath*)indexPath
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
    
    [cell.openMeetingSwitch setOn:self.openMeeting animated:YES];
    [cell.openMeetingSwitch addTarget:self action:@selector(openMeetingSwitchTapped:) forControlEvents:UIControlEventValueChanged];
    
    cell.fellowshipIcon.format = self.format;
    cell.fellowshipIcon.program = self.program;
    cell.fellowshipIcon.isOpen = self.openMeeting;
    self.fellowshipIcon = cell.fellowshipIcon;
    cell.bottomSeparator = YES;
    
    return cell;
}

- (AAEditMeetingFormatPickerCell*)formatCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingFormatPickerCell* cell = (AAEditMeetingFormatPickerCell*)[self.tableView dequeueReusableCellWithIdentifier:FORMAT_PICKER_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingFormatPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FORMAT_PICKER_CELL_REUSE_ID];
    }
    
    cell.titleLabel.text = NSLocalizedString(@"Format", @"12 step meeting format");
    cell.format = self.format;
    cell.delegate = self;
    cell.bottomSeparator = YES;
    
    return cell;
}

- (AAEditMeetingProgramTypeCell*)programCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingProgramTypeCell* cell = (AAEditMeetingProgramTypeCell*)[self.tableView dequeueReusableCellWithIdentifier:PROGRAM_TYPE_CELL_REUSE_ID];
    
    cell.programNameLabel.text = self.program.localizedTitle;
    
    return cell;
}

#pragma mark Cell Interaction

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
    [self updateSelectedCellIndexPath:nil];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == TITLE_INPUT_FIELD_TAG) {
        NSString* result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([result isEqualToString:@""]) {
            self.rightToolbarItem.enabled = NO;
        } else {
            self.rightToolbarItem.enabled = YES;
        }
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
    if ([segue.identifier isEqualToString:@"programs"]) {
        AAEditMeetingProgramViewController* aaempvc = (AAEditMeetingProgramViewController*)segue.destinationViewController;
        aaempvc.programDelegate = self;
        aaempvc.program = self.program;
    }
}

@end
