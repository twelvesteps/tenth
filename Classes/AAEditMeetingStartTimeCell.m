//
//  AAEditMeetingDateTimeInputCell.m
//  Steps
//
//  Created by Tom on 11/29/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingStartTimeCell.h"

@implementation AAEditMeetingStartTimeCell

- (void)initPicker
{
    [super initPicker];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    self.datePicker.minuteInterval = 5;
}

- (AAEditMeetingPickerCellType)type
{
    return AAEditMeetingPickerCellTypeStartTime;
}

@end
