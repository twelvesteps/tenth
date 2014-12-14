//
//  AAMeetingDurationPickerView.m
//  Steps
//
//  Created by Tom on 12/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingDurationPickerView.h"
@interface AAMeetingDurationPickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation AAMeetingDurationPickerView

#pragma mark - Lifecycle and Properties

#define HOUR_COMPONENT          0
#define HOUR_LABEL_COMPONENT    1
#define MINUTE_COMPONENT        2
#define MINUTE_LABEL_COMPONENT  3

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.delegate = self;
    self.dataSource = self;
    
    self.minuteInterval = 5;
    
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = 1;
    self.date = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:dateComponents];    
}

@synthesize textColor = _textColor;

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self reloadAllComponents];
}

- (UIColor*)textColor
{
    if (!_textColor) {
        _textColor = [UIColor darkTextColor];
    }
    
    return _textColor;
}

- (void)setMinuteInterval:(NSInteger)minuteInterval
{
    if (60 % minuteInterval != 0) {
        _minuteInterval = 5;
    } else {
        _minuteInterval = minuteInterval;
    }
    
    [self reloadComponent:MINUTE_COMPONENT];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [self selectDate];
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    if ([dataSource isEqual:self]) {
        [super setDataSource:dataSource];
    } else {
        // ignore method
    }
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate
{
    if ([delegate isEqual:self]) {
        [super setDelegate:delegate];
    } else {
        // ignore method
    }
}


#pragma mark - UI Events

- (void)updateDate
{
    NSInteger hourRow = [self selectedRowInComponent:HOUR_COMPONENT];
    NSInteger minuteRow = [self selectedRowInComponent:MINUTE_COMPONENT];
    
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    
    dateComponents.hour = hourRow;
    dateComponents.minute = minuteRow * self.minuteInterval;
    
    self.date = [calendar dateFromComponents:dateComponents];
}

- (void)selectDate
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.date];
    
    [self selectRow:components.hour inComponent:HOUR_COMPONENT animated:NO];
    [self selectRow:(components.minute / self.minuteInterval) inComponent:MINUTE_COMPONENT animated:NO];
}


#pragma mark - Date Picker Delegate and Datasource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component != HOUR_LABEL_COMPONENT && component != MINUTE_LABEL_COMPONENT) {
        [self updateDate];
        [self reloadComponent:component + 1];
        [self.durationDelegate pickerView:self didSelectRow:row inComponent:component];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case HOUR_COMPONENT:
            return 24;
            
        case MINUTE_COMPONENT:
            return 60 / self.minuteInterval;
            
        case MINUTE_LABEL_COMPONENT:
        case HOUR_LABEL_COMPONENT:
            return 1;
            
        default:
            return 0;
    }
}

- (NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case HOUR_COMPONENT:
            return [self hourAttributedStringForRow:row];
        
        case MINUTE_COMPONENT:
            return [self minuteAttributedStringForRow:row];
            
        case HOUR_LABEL_COMPONENT:
        case MINUTE_LABEL_COMPONENT:
            return [self labelAttributedStringForComponent:component];

            
        default:
            return [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName : self.textColor}];
    }
}

- (NSAttributedString*)hourAttributedStringForRow:(NSInteger)row
{
    NSString* hourString = [NSString stringWithFormat:@"%d", (int)row];
    return [self attributedTitleWithString:hourString];
}

- (NSAttributedString*)minuteAttributedStringForRow:(NSInteger)row
{
    NSString* minuteString = [NSString stringWithFormat:@"%d", (int)(row * self.minuteInterval)];
    return [self attributedTitleWithString:minuteString];
}

- (NSAttributedString*)labelAttributedStringForComponent:(NSInteger)component
{
    if (component == HOUR_LABEL_COMPONENT) {
        NSString* hourLabelString = [AAMeetingDurationPickerView hourString:[self selectedRowInComponent:HOUR_COMPONENT]];
        return [self attributedTitleWithString:hourLabelString];
    } else if (component == MINUTE_LABEL_COMPONENT) {
        NSString* minuteLabelString = [AAMeetingDurationPickerView minuteString:([self selectedRowInComponent:MINUTE_COMPONENT] * self.minuteInterval)];
        return [self attributedTitleWithString:minuteLabelString];
    } else {
        return [self attributedTitleWithString:@""];
    }
}

- (NSAttributedString*)attributedTitleWithString:(NSString*)string
{
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : self.textColor}];
}


#pragma mark - Class Methods

+ (NSString*)hourString:(NSInteger)hours
{
    return [NSString localizedStringWithFormat:NSLocalizedString(@"%d hours", @"{num hours} hours"), hours];
}

+ (NSString*)minuteString:(NSInteger)minutes
{
    return [NSString localizedStringWithFormat:NSLocalizedString(@"%d min", @"{num minutes} min"), minutes];
}

+ (NSString*)localizedDurationStringForDate:(NSDate *)date
{
    NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    
    return [NSString localizedStringWithFormat:NSLocalizedString(@"%d hours %d min", @"{num hours} hours {num minutes} minutes"), components.hour, components.minute];
}

@end
