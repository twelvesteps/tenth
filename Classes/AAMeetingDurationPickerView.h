//
//  AAMeetingDurationPickerView.h
//  Steps
//
//  Created by Tom on 12/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAMeetingDurationPickerView;
@protocol AAMeetingDurationPickerViewDelegate <NSObject>

- (void)pickerView:(AAMeetingDurationPickerView*)pv didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@interface AAMeetingDurationPickerView : UIPickerView

// The currently selected time on the picker.
@property (strong, nonatomic) NSDate* date; // default = 1 hour

// The color to use for the picker's labels
@property (strong, nonatomic) UIColor* textColor; // default = [UIColor darkTextColor]

// The interval between minutes on the duration timer.
// Must evenly divide 60 or a default value will be used
@property (nonatomic) NSInteger minuteInterval; // default = 5

// Receives messages when the picker value changes.
// Use this property instead of UIPickerView's delegate and datasource properties.
// Attempts to write to datasource and delegate will be ignored.
@property (weak, nonatomic) id<AAMeetingDurationPickerViewDelegate> durationDelegate;

+ (NSString*)localizedDurationStringForDate:(NSDate*)date;

@end
