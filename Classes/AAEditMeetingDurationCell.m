//
//  AAEditMeetingDurationCell.m
//  Steps
//
//  Created by Tom on 12/3/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingDurationCell.h"
#import "AAMeetingDurationPickerView.h"
#import "UIColor+AAAdditions.h"

@interface AAEditMeetingDurationCell() <AAMeetingDurationPickerViewDelegate>

@end

@implementation AAEditMeetingDurationCell

- (void)initPicker
{
    AAMeetingDurationPickerView* durationPicker = [[AAMeetingDurationPickerView alloc] init];
    
    durationPicker.durationDelegate = self;
    durationPicker.textColor = [UIColor stepsBlueTextColor];
    durationPicker.minuteInterval = 5;
    
    self.durationPicker = durationPicker;
    [self addSubview:durationPicker];
}

- (UIPickerView*)picker
{
    return self.durationPicker;
}

- (AAEditMeetingPickerCellType)type
{
    return AAEditMeetingPickerCellTypeDuration;
}


#pragma mark - Duration Picker View Delegate and Datasource

- (void)pickerView:(AAMeetingDurationPickerView *)pv didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.delegate pickerCellValueChanged:self];
}

@end
