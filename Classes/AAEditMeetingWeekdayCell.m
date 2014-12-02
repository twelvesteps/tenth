//
//  AAEditMeetingWeekdayCell.m
//  Steps
//
//  Created by Tom on 12/3/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingWeekdayCell.h"
@interface AAEditMeetingWeekdayCell() <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation AAEditMeetingWeekdayCell

#pragma mark - Lifecycle And Properties

- (void)initPicker
{
    [super initPicker];
    self.picker.delegate = self;
    self.picker.dataSource = self;
}

- (AAEditMeetingPickerCellType)type
{
    return AAEditMeetingPickerCellTypeWeekday;
}

- (void)setSelectedWeekday:(NSInteger)selectedWeekday
{
    _selectedWeekday = selectedWeekday;
    [self.picker selectRow:selectedWeekday - 1 inComponent:0 animated:YES];
}

- (NSString*)currentWeekdaySymbol
{
    NSInteger weekdayIndex = self.selectedWeekday - 1;
    return [NSCalendar autoupdatingCurrentCalendar].weekdaySymbols[weekdayIndex];
}


#pragma mark - Picker View Delegate and Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [NSCalendar autoupdatingCurrentCalendar].weekdaySymbols.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSCalendar autoupdatingCurrentCalendar].weekdaySymbols[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedWeekday = [self.picker selectedRowInComponent:0] + 1;
    
    [self.delegate pickerCellValueChanged:self];
}

@end
