//
//  AAEditMeetingFormatPickerCell.m
//  Steps
//
//  Created by Tom on 12/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingFormatPickerCell.h"

#import "AAMeetingFormatView.h"

#import "Meeting+AAAdditions.h"
#import "UIColor+AAAdditions.h"
#import "AAUserSettingsManager.h"
@interface AAEditMeetingFormatPickerCell() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) AAMeetingFormatView* formatView;

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

- (AAMeetingFormatView*)formatView
{
    if (!_formatView) {
        CGRect formatViewFrame = CGRectMake(0.0f,
                                            0.0f,
                                            [AAMeetingFormatView widthForFormat:self.format],
                                            FORMAT_VIEW_HEIGHT);

        AAMeetingFormatView* formatView = [[AAMeetingFormatView alloc] initWithFrame:formatViewFrame];
        formatView.format = self.format;
        
        self.formatView = formatView;
        [self addSubview:formatView];
    }
    
    return _formatView;
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
    self.formatView.format = self.format;
    [self setNeedsLayout];
}

#pragma mark - Layout 

#define HORIZONTAL_INSET    8.0f

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutFormatView];
}

- (void)layoutFormatView
{
    CGFloat formatWidth = [AAMeetingFormatView widthForFormat:self.format];
    CGFloat formatViewOriginX = CGRectGetMaxX(self.bounds) - formatWidth - HORIZONTAL_INSET;
    CGFloat formatViewOriginY = self.bounds.origin.y + (LABEL_BLOCK_HEIGHT - FORMAT_VIEW_HEIGHT) / 2.0f;
    CGRect formatViewFrame = CGRectMake(formatViewOriginX,
                                        formatViewOriginY,
                                        formatWidth,
                                        FORMAT_VIEW_HEIGHT);
    
    self.formatView.frame = formatViewFrame;
}


#pragma mark - Picker View Delegate and Datasource

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    switch ((AAMeetingFormat)row) {
        case AAMeetingFormatUnspecified:
        case AAMeetingFormatBeginner:
        case AAMeetingFormatDiscussion:
        case AAMeetingFormatLiterature:
        case AAMeetingFormatSpeaker:
        case AAMeetingFormatStepStudy:
            break;
            
        default:
            [NSException raise:@"InvalidMeetingType" format:@"The meeting format was set incorrectly"];
    }
    
    CGRect formatViewFrame = CGRectMake(0.0, 0.0, [AAMeetingFormatView widthForFormat:(AAMeetingFormat)row], 23.0f);
    AAMeetingFormatView* formatView = [[AAMeetingFormatView alloc] initWithFrame:formatViewFrame];
    formatView.format = (AAMeetingFormat)row;
    
    return formatView;
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
