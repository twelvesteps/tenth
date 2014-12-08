//
//  AAEditMeetingPickerCell.h
//  Steps
//
//  Created by Tom on 12/1/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AASeparatorTableViewCell.h"

@class AAEditMeetingPickerCell;
@protocol AAEditMeetingPickerCellDelegate <NSObject>

- (void)pickerCellValueChanged:(AAEditMeetingPickerCell*)cell;

@end

typedef NS_ENUM(NSInteger, AAEditMeetingPickerCellType) {
    AAEditMeetingPickerCellTypeDuration,
    AAEditMeetingPickerCellTypeStartTime,
    AAEditMeetingPickerCellTypeWeekday,
};

@interface AAEditMeetingPickerCell : AASeparatorTableViewCell

@property (nonatomic) AAEditMeetingPickerCellType type;

@property (nonatomic, weak) id<AAEditMeetingPickerCellDelegate> delegate;

@property (nonatomic, weak) UIPickerView* picker;
@property (nonatomic) BOOL pickerHidden;

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *descriptionLabel;

- (void)initPicker;

@end
