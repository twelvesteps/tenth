//
//  AAEditMeetingFormatPickerCell.m
//  Steps
//
//  Created by Tom on 12/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingFormatPickerCell.h"
#import "Meeting+AAAdditions.h"
#import "UIColor+AAAdditions.h"
#import "AAUserSettingsManager.h"
@interface AAEditMeetingFormatPickerCell() <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation AAEditMeetingFormatPickerCell

- (void)initPicker
{
    [super initPicker];
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
}

- (AAEditMeetingPickerCellType)type
{
    return AAEditMeetingPickerCellTypeMeetingFormat;
}

- (AAMeetingFormat)selectedFormat
{
    return (AAMeetingFormat)[self.picker selectedRowInComponent:0];
}


#pragma mark - Picker View Delegate and Datasource

- (NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* formatString;
    switch ((AAMeetingFormat)row) {
        case AAMeetingFormatBeginner:
        case AAMeetingFormatDiscussion:
        case AAMeetingFormatLiterature:
        case AAMeetingFormatSpeaker:
        case AAMeetingFormatStepStudy:
            formatString = [Meeting stringForMeetingFormat:(AAMeetingFormat)row];
            break;
            
        default:
            [NSException raise:@"InvalidMeetingType" format:@"The meeting format was set incorrectly"];
    }
    UIColor* meetingColor = [[AAUserSettingsManager sharedManager] colorForMeetingFormat:(AAMeetingFormat)row];
    return [[NSAttributedString alloc] initWithString:formatString attributes:@{NSForegroundColorAttributeName : meetingColor}];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.delegate pickerCellValueChanged:self];
}

@end
