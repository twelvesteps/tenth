//
//  AAEditMeetingFormatPickerCell.m
//  Steps
//
//  Created by Tom on 12/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingFormatPickerCell.h"
#import "AAMeetingFormatLabel.h"

#import "Meeting+AAAdditions.h"
#import "UIColor+AAAdditions.h"
#import "AAUserSettingsManager.h"
@interface AAEditMeetingFormatPickerCell() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) AAMeetingFormatLabel* formatLabel;

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

- (AAMeetingFormatLabel*)formatLabel
{
    if (!_formatLabel) {
        AAMeetingFormatLabel* formatLabel = [[AAMeetingFormatLabel alloc] init];

        formatLabel.format = self.format;
        
        _formatLabel = formatLabel;
        [self addSubview:formatLabel];
    }
    
    return _formatLabel;
}

- (AAEditMeetingPickerCellType)type
{
    return AAEditMeetingPickerCellTypeMeetingFormat;
}

- (void)setFormat:(AAMeetingFormat)format
{
    _format = format;
    [self.picker selectRow:(NSInteger)format inComponent:0 animated:YES];
    [self updateViews];
}

- (void)updateViews
{
    self.formatLabel.format = self.format;
    [self setNeedsLayout];
}

#pragma mark - Layout 

#define HORIZONTAL_INSET    8.0f

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutFormatLabel];
}

- (void)layoutFormatLabel
{
    CGSize boundingSize = CGSizeMake(self.bounds.size.width - self.titleLabel.frame.size.width - 2 * HORIZONTAL_INSET, self.bounds.size.height);
    CGFloat formatWidth = [AAMeetingLabel widthForText:[Meeting stringForMeetingFormat:self.format] boundingSize:boundingSize];
    CGFloat formatLabelOriginX = CGRectGetMaxX(self.bounds) - formatWidth - HORIZONTAL_INSET;
    CGRect formatLabelFrame = CGRectMake(formatLabelOriginX,
                                         self.bounds.origin.y,
                                         formatWidth,
                                         LABEL_BLOCK_HEIGHT);
    
    self.formatLabel.frame = formatLabelFrame;
}


#pragma mark - Picker View Delegate and Datasource

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    AAMeetingFormat format;
    switch ((AAMeetingFormat)row) {
        case AAMeetingFormatUnspecified:
        case AAMeetingFormatBeginner:
        case AAMeetingFormatDiscussion:
        case AAMeetingFormatLiterature:
        case AAMeetingFormatSpeaker:
        case AAMeetingFormatStepStudy:
            format = (AAMeetingFormat)row;
            break;
            
        default:
            [NSException raise:@"InvalidMeetingType" format:@"The meeting format was set incorrectly"];
    }
    
    
    CGFloat formatLabelWidth = [AAMeetingLabel widthForText:[Meeting stringForMeetingFormat:format] boundingSize:self.picker.bounds.size];
    CGRect labelFrame = CGRectMake(0.0f, 0.0f, formatLabelWidth, 23.0f);
    
    AAMeetingFormatLabel* formatLabel = [[AAMeetingFormatLabel alloc] initWithFrame:labelFrame];
    formatLabel.format = format;
    
    
    return formatLabel;
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
