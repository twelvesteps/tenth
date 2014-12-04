//
//  AAEditMeetingViewController.m
//  Steps
//
//  Created by Tom on 11/29/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserDataManager.h"

#import "AAEditMeetingViewController.h"
#import "AAEditMeetingTextInputCell.h"
#import "AAEditMeetingWeekdayCell.h"
#import "AAEditMeetingDurationCell.h"
#import "AAEditMeetingStartTimeCell.h"

#import "Meeting+AAAdditions.h"
#import "NSDate+AAAdditions.h"
#import "UIColor+AAAdditions.h"


@interface AAEditMeetingViewController() <AAEditMeetingPickerCellDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightToolbarItem; // add/edit

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UITextField* titleTextField;
@property (weak, nonatomic) UITextField* locationTextField;

@property (strong, nonatomic) NSIndexPath* selectedIndexPath;

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* location;

@property (nonatomic) NSInteger weekday;
@property (strong, nonatomic) NSDate* startTime;
@property (strong, nonatomic) NSDate* duration;

@end

@implementation AAEditMeetingViewController

#pragma mark - Lifecycle and Properties

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.meeting) {
        self.rightToolbarItem.title = NSLocalizedString(@"Done", @"Done editing the meeting");
    } else {
        self.rightToolbarItem.title = NSLocalizedString(@"Add", @"Add the meeting to the calendar");
        self.rightToolbarItem.enabled = NO;
    }
    
    if (self.meeting) {
        self.title = NSLocalizedString(@"Edit Meeting", @"Edit the selected meeting's details");
        self.weekday = [self.meeting.startDate weekday];
        self.startTime = self.meeting.startDate;
        self.duration = self.meeting.duration;
    } else {
        self.title = NSLocalizedString(@"New Meeting", @"Create a new meeting");
        self.weekday = [[NSDate date] weekday];
        self.startTime = [[NSDate date] nearestHalfHour];
        self.duration = [NSDate oneHour];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self setupTableviewHeaderAndFooter];
}

- (void)setupTableviewHeaderAndFooter
{
    CGFloat dummyViewHeight = self.view.bounds.size.height;
    CGRect dummyViewFrame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, dummyViewHeight);
    
    UIView* dummyHeader = [[UIView alloc] initWithFrame:dummyViewFrame]; // Allows header views to scroll
    UIView* dummyFooter = [[UIView alloc] initWithFrame:dummyViewFrame]; // Creates consistent color scheme
    dummyHeader.backgroundColor = [UIColor groupTableViewBackgroundColor];
    dummyFooter.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.tableHeaderView = dummyHeader;
    self.tableView.tableFooterView = dummyFooter;
    self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, -dummyViewHeight, 0);
}


#pragma mark - Meeting

- (void)syncMeeting
{
    if (!self.meeting) {
        self.meeting = [[AAUserDataManager sharedManager] createMeeting];
    }

    self.meeting.title = self.titleTextField.text;
    self.meeting.address = self.locationTextField.text;
    
    self.meeting.startDate = [self dateByCombiningWeekdayAndStartTime];
    self.meeting.duration = self.duration;
}

- (NSDate*)dateByCombiningWeekdayAndStartTime
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dateComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.startTime];
    dateComponents.weekday = self.weekday;
    
    return [calendar dateFromComponents:dateComponents];
}


#pragma mark - UI Events

- (IBAction)leftToolbarButtonTapped:(UIBarButtonItem *)sender
{
    [self.delegate viewControllerDidCancel:self];
}

- (IBAction)rightToolbarButtonTapped:(UIBarButtonItem *)sender
{
    [self syncMeeting];
    [self.delegate viewControllerDidFinish:self];
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
    self.duration = cell.datePicker.date;
    cell.descriptionLabel.text = [self durationStringForDate:self.duration];
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
    }
}


#pragma mark - Tableview Delegate and DataSource

#define TEXT_INPUT_CELL_REUSE_ID        @"TextInputCell"
#define WEEKDAY_PICKER_CELL_REUSE_ID    @"WeekdayInputCell"
#define START_TIME_PICKER_CELL_REUSE_ID @"StartTimeCell"
#define DURATION_PICKER_CELL_REUSE_ID   @"DurationInputCell"


#define TITLE_LOCATION_SECTION          0
#define DATE_TIME_SECTION               1

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
            
        default:
            return 0;
    }
}

#define HEADER_VIEW_HEIGHT  22.0f

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect headerViewFrame = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT);
    
    UIView* headerView = [[UIView alloc] initWithFrame:headerViewFrame];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return headerView;
}

#define TEXT_CELL_HEIGHT    32.0f
#define PICKER_CELL_HEIGHT  216.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.selectedIndexPath]) {
        return TEXT_CELL_HEIGHT + PICKER_CELL_HEIGHT;
    } else {
        return TEXT_CELL_HEIGHT;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case TITLE_LOCATION_SECTION:
            return [self textInputCellForIndexPath:indexPath];
            
        case DATE_TIME_SECTION:
            return [self dateTimeCellForIndexPath:indexPath];
            
        default:
            return nil;
    }
}

#define TITLE_ROW_INDEX             0
#define LOCATION_ROW_INDEX          1

#define TITLE_INPUT_FIELD_TAG       100
#define LOCATION_INPUT_FIELD_TAG    101

- (UITableViewCell*)textInputCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingTextInputCell* cell = (AAEditMeetingTextInputCell*)[self.tableView dequeueReusableCellWithIdentifier:TEXT_INPUT_CELL_REUSE_ID];
    
    if (indexPath.row == TITLE_ROW_INDEX) {
        cell.textField.placeholder = NSLocalizedString(@"Title", @"Meeting Title");
        cell.textField.tag = TITLE_INPUT_FIELD_TAG;
        self.titleTextField = cell.textField;
    } else {
        cell.textField.placeholder = NSLocalizedString(@"Location", @"Meeting Location");
        cell.textField.tag = LOCATION_INPUT_FIELD_TAG;
        self.locationTextField = cell.textField;
    }
    
    cell.textField.delegate = self;
    
    return cell;
}

#define WEEKDAY_ROW                     0
#define START_TIME_ROW                  1
#define DURATION_ROW                    2

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
    
    return cell;
}

- (AAEditMeetingPickerCell*)durationCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingDurationCell* cell = [self.tableView dequeueReusableCellWithIdentifier:DURATION_PICKER_CELL_REUSE_ID];
    
    if (!cell) {
        cell = [[AAEditMeetingDurationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DURATION_PICKER_CELL_REUSE_ID];
    }
    
    cell.titleLabel.text = NSLocalizedString(@"Duration", @"The length of the meeting in hours and minutes");
    cell.descriptionLabel.text = [self durationStringForDate:self.duration];
    cell.datePicker.date = self.duration;
    
    return cell;
}

- (NSString*)timeStringForDate:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"j:mm" options:0 locale:[NSLocale autoupdatingCurrentLocale]];
    
    return [formatter stringFromDate:date];
}

- (NSString*)durationStringForDate:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    
    return [NSString localizedStringWithFormat:NSLocalizedString(@"%d hr %d min", @"{num_hours} hrs {num_minutes} min"), components.hour, components.minute];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateSelectedCellIndexPath:indexPath];
    
    if (indexPath.section == DATE_TIME_SECTION) {
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

@end
