//
//  AADailyInventoryQuestionTableViewCell.h
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AADailyInventoryQuestion.h"

@interface AADailyInventoryQuestionTableViewCell : UITableViewCell

@property (strong, nonatomic) AADailyInventoryQuestion* question;
@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;
@property (weak, nonatomic) IBOutlet UISwitch *yesNoSwitch;

@end
