//
//  AAEditMeetingDurationCell.m
//  Steps
//
//  Created by Tom on 12/3/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingDurationCell.h"
@interface AAEditMeetingDurationCell()

@end

@implementation AAEditMeetingDurationCell

- (void)initPicker
{
    [super initPicker];
    self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
}

- (AAEditMeetingPickerCellType)type
{
    return AAEditMeetingPickerCellTypeDuration;
}

@end
