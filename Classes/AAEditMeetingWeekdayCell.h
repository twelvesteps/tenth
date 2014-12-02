//
//  AAEditMeetingWeekdayCell.h
//  Steps
//
//  Created by Tom on 12/3/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingPickerCell.h"

@interface AAEditMeetingWeekdayCell : AAEditMeetingPickerCell

@property (nonatomic) NSInteger selectedWeekday;

- (NSString*)currentWeekdaySymbol;

@end
