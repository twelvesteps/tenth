//
//  AAEditMeetingViewController.m
//  Steps
//
//  Created by Tom on 11/29/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingViewController.h"
#import "AAEditMeetingDescriptionCell.h"
#import "AAEditMeetingTextInputCell.h"
#import "AAEditMeetingDateTimeInputCell.h"
#import "AAEditMeetingWeekdayPickerCell.h"


@interface AAEditMeetingViewController()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightToolbarItem; // add/edit

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL dateTimePickerHidden;
@property (strong, nonatomic) NSIndexPath* dateTimePickerIndexPath;

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
}

- (BOOL)dateTimePickerHidden
{
    return !self.dateTimePickerIndexPath;
}

#pragma mark - UI Events

- (IBAction)leftToolbarButtonTapped:(UIBarButtonItem *)sender
{
    [self.delegate viewControllerDidCancel:self];
}

- (IBAction)rightToolbarButtonTapped:(UIBarButtonItem *)sender
{
    
}


#pragma mark - Tableview Delegate and DataSource

#define TEXT_INPUT_CELL_REUSE_ID        @"TextInputCell"
#define DESCRIPTION_CELL_REUSE_ID       @"DescriptionCell"
#define DATE_TIME_PICKER_CELL_REUSE_ID  @"TimeInputCell"
#define WEEKDAY_PICKER_CELL_REUSE_ID    @"WeekdayInputCell"

#define TITLE_LOCATION_SECTION_INDEX    0
#define DATE_TIME_SECTION_INDEX         1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case TITLE_LOCATION_SECTION_INDEX:
            return 2;
            
        case DATE_TIME_SECTION_INDEX:
            if (self.dateTimePickerHidden) {
                return 3;
            } else {
                return 4;
            }
            
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case TITLE_LOCATION_SECTION_INDEX:
            return [self textInputCellForIndexPath:indexPath];
            
        case DATE_TIME_SECTION_INDEX:
            return [self dateTimeCellForIndexPath:indexPath];
            
        default:
            return nil;
    }
}

#define TITLE_ROW_INDEX     0
#define LOCATION_ROW_INDEX  1

- (UITableViewCell*)textInputCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingTextInputCell* cell = (AAEditMeetingTextInputCell*)[self.tableView dequeueReusableCellWithIdentifier:TEXT_INPUT_CELL_REUSE_ID];
    
    if (indexPath.row == TITLE_ROW_INDEX) {
        cell.textField.placeholder = NSLocalizedString(@"Title", @"Meeting Title");
    } else {
        cell.textField.placeholder = NSLocalizedString(@"Location", @"Meeting Location");
    }
    
    return cell;
}

- (UITableViewCell*)dateTimeCellForIndexPath:(NSIndexPath*)indexPath
{
    if (self.dateTimePickerHidden ||
        ![self.dateTimePickerIndexPath isEqual:indexPath]) {
        return [self dateTimeDescriptionCellForIndexPath:indexPath];
    } else {
        return [self dateTimeInputCellForIndexPath:indexPath];
    }
}

#define WEEKDAY_ROW_INDEX       0
#define START_TIME_ROW_INDEX    1
#define DURATION_ROW_INDEX      2

- (UITableViewCell*)dateTimeDescriptionCellForIndexPath:(NSIndexPath*)indexPath
{
    AAEditMeetingDescriptionCell* cell = [self.tableView dequeueReusableCellWithIdentifier:DESCRIPTION_CELL_REUSE_ID];
    
    
}

- (UITableViewCell*)dateTimeInputCellForIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == WEEKDAY_ROW_INDEX + 1) {
        AAEditMeetingWeekdayPickerCell* cell = [self.tableView dequeueReusableCellWithIdentifier:WEEKDAY_PICKER_CELL_REUSE_ID];
    }
}


@end
