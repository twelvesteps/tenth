//
//  AADailyInventoryYesNoQuestionTableViewCell.h
//  Steps
//
//  Created by Tom on 5/15/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AADailyInventoryQuestionTableViewCell.h"

@class AADailyInventoryYesNoQuestionTableViewCell;

@protocol AADailyInventoryYesNoQuestionTableViewCellDelegate <NSObject>

- (void)tableViewCellSwitchDidChangeValue:(AADailyInventoryYesNoQuestionTableViewCell*)cell;

@end

#define AA_DAILY_INVENTORY_QUESTION_ACCESSORY_BUTTON_SPONSOR    @"sponsor"
#define AA_DAILY_INVENTORY_QUESTION_ACCESSORY_BUTTON_RANDOM     @"random"
#define AA_DAILY_INVENTORY_QUESTION_ACCESSORY_BUTTON_OTHER      @"other"

@interface AADailyInventoryYesNoQuestionTableViewCell : AADailyInventoryQuestionTableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *yesNoSwitch;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *callButtons;

@property (weak, nonatomic) id<AADailyInventoryYesNoQuestionTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *buttonHeightLayoutConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *buttonBottomSpacingLayoutConstraints;


@end
