//
//  AAEditMeetingWeekdayCell.m
//  Steps
//
//  Created by Tom on 12/3/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingWeekdayCell.h"
#import "UIColor+AAAdditions.h"
@interface AAEditMeetingWeekdayCell() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray* weekdaySymbols;

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

- (void)setSelectedWeekday:(AADateWeekday)selectedWeekday
{
    _selectedWeekday = selectedWeekday;
    [self.picker selectRow:selectedWeekday inComponent:0 animated:YES];
}

- (NSString*)currentWeekdaySymbol
{
    NSInteger weekdayIndex = self.selectedWeekday;
    return self.weekdaySymbols[weekdayIndex];
}

- (NSArray*)weekdaySymbols
{
    if (!_weekdaySymbols) {
        [self updateWeekdaySymbols];
    }
    
    return _weekdaySymbols;
}

- (void)updateWeekdaySymbols
{
    NSMutableArray* mutableSymbols = [NSMutableArray arrayWithArray:[NSCalendar autoupdatingCurrentCalendar].weekdaySymbols];
    [mutableSymbols insertObject:NSLocalizedString(@"None", @"The meeting does not reccur on a given weekday") atIndex:0];
    _weekdaySymbols = [mutableSymbols copy];
}

- (NSString*)weekdaySymbolForWeekday:(AADateWeekday)weekday
{
    switch (weekday) {
        case AADateWeekdayUndefined:
        case AADateWeekdaySunday:
        case AADateWeekdayMonday:
        case AADateWeekdayTuesday:
        case AADateWeekdayWednesday:
        case AADateWeekdayThursday:
        case AADateWeekdayFriday:
        case AADateWeekdaySaturday:
            return self.weekdaySymbols[(NSInteger)weekday];
            
        default:
            DLog(@"<DEBUG> Unrecognized weekday enumeration value %d", (int)weekday);
            return nil;
    }

}


#pragma mark - Picker View Delegate and Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.weekdaySymbols.count;
}

- (NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* weekdaySymbol = self.weekdaySymbols[row];
    NSAttributedString* blueWeekdaySymbol = [[NSAttributedString alloc] initWithString:weekdaySymbol attributes:@{NSForegroundColorAttributeName : [UIColor stepsBlueColor]}];
    return blueWeekdaySymbol;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedWeekday = [self.picker selectedRowInComponent:0];
    
    [self.delegate pickerCellValueChanged:self];
}

@end
