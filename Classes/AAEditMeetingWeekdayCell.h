//
//  AAEditMeetingWeekdayCell.h
//  Steps
//
//  Created by Tom on 12/3/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingPickerCell.h"

typedef NS_ENUM(NSInteger, AADateWeekday) {
    AADateWeekdayUndefined = 0,
    AADateWeekdaySunday = 1,
    AADateWeekdayMonday = 2,
    AADateWeekdayTuesday = 3,
    AADateWeekdayWednesday = 4,
    AADateWeekdayThursday = 5,
    AADateWeekdayFriday = 6,
    AADateWeekdaySaturday = 7,
};

@interface AAEditMeetingWeekdayCell : AAEditMeetingPickerCell

@property (nonatomic) AADateWeekday selectedWeekday;

- (NSString*)currentWeekdaySymbol;
- (NSString*)weekdaySymbolForWeekday:(AADateWeekday)weekday;

@end
