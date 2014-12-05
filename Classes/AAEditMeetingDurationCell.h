//
//  AAEditMeetingDurationCell.h
//  Steps
//
//  Created by Tom on 12/3/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingDatePickerCell.h"
#import "AAMeetingDurationPickerView.h"
@interface AAEditMeetingDurationCell : AAEditMeetingPickerCell

@property (weak, nonatomic) AAMeetingDurationPickerView* durationPicker;

@end
