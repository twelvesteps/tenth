//
//  AAEditMeetingDatePickerCell.m
//  Steps
//
//  Created by Tom on 12/3/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingDatePickerCell.h"

@implementation AAEditMeetingDatePickerCell

#pragma mark - Lifecycle and Properties

- (void)initPicker
{
    if (!self.datePicker) {
        UIDatePicker* datePicker = [[UIDatePicker alloc] init];
        
        [self addSubview:datePicker];
        self.datePicker = datePicker;
        [self.datePicker addTarget:self action:@selector(datePickerScrolled:) forControlEvents:UIControlEventValueChanged];
    }
}

- (UIPickerView*)picker
{
    return (UIPickerView*)self.datePicker;
}


#pragma mark - UI Events

- (void)datePickerScrolled:(UIDatePicker*)sender
{
    [self.delegate pickerCellValueChanged:self];
}

@end
