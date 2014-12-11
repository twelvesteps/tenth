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

@synthesize pickerHidden = _pickerHidden;

- (void)setPickerHidden:(BOOL)pickerHidden
{
    _pickerHidden = pickerHidden;
    
    [self setNeedsLayout];
}

- (AAEditMeetingPickerCellType)type
{
    return AAEditMeetingPickerCellTypeMeetingFormat;
}

- (void)setFormat:(AAMeetingFormat)format
{
    _format = format;
    [self.picker selectRow:(NSInteger)format inComponent:0 animated:YES];
    [self updateLabels];
}

- (void)updateLabels
{
    self.descriptionLabel.text = [Meeting stringForMeetingFormat:self.format];
    self.descriptionLabel.textColor = [[AAUserSettingsManager sharedManager] colorForMeetingFormat:self.format];
}


#pragma mark - Picker View Delegate and Datasource

- (NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* formatString;
    switch ((AAMeetingFormat)row) {
        case AAMeetingFormatUnspecified:
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
    return MEETING_FORMAT_COUNT;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.format = (AAMeetingFormat)[self.picker selectedRowInComponent:0];
    
    [self.delegate pickerCellValueChanged:self];
}

@end
