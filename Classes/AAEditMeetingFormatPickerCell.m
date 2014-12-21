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
#import "AAUserMeetingsManager.h"

#define UNSPECIFIED_FORMAT_ROW  0

@interface AAEditMeetingFormatPickerCell() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) AAMeetingFormatLabel* formatLabel;
@property (nonatomic, strong) NSArray* meetingFormats;

@end

@implementation AAEditMeetingFormatPickerCell

- (void)initPicker
{
    [super initPicker];
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
}

- (NSArray*)meetingFormats
{
    if (!_meetingFormats) {
        _meetingFormats = [[AAUserMeetingsManager sharedManager] fetchMeetingFormats];
    }
    
    return _meetingFormats;
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

- (void)setFormat:(MeetingFormat*)format
{
    _format = format;
    if (format) {
        [self.picker selectRow:[self.meetingFormats indexOfObject:format] + 1 inComponent:0 animated:YES];
    } else {
        [self.picker selectRow:UNSPECIFIED_FORMAT_ROW inComponent:0 animated:YES];
    }
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
    CGFloat formatWidth = [AAMeetingLabel widthForText:self.format.localizedTitle boundingSize:boundingSize];
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
    MeetingFormat* format = nil;
    if (row == UNSPECIFIED_FORMAT_ROW) {
        format = nil;
    } else {
        format = [self.meetingFormats objectAtIndex:row - 1];
    }
    
    CGFloat formatLabelWidth = [AAMeetingLabel widthForText:format.localizedTitle boundingSize:self.picker.bounds.size];
    CGRect labelFrame = CGRectMake(0.0f, 0.0f, formatLabelWidth, 23.0f);
    
    AAMeetingFormatLabel* formatLabel = [[AAMeetingFormatLabel alloc] initWithFrame:labelFrame];
    formatLabel.format = format;
    
    
    return formatLabel;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.meetingFormats.count + 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == UNSPECIFIED_FORMAT_ROW) {
        self.format = nil;
    } else {
        self.format = [self.meetingFormats objectAtIndex:[pickerView selectedRowInComponent:component] - 1];
    }
    
    [self.delegate pickerCellValueChanged:self];
}

@end
