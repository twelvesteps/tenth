//
//  AADailyInventoryQuestionTableViewCell.h
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryQuestion+AAAdditions.h"

@interface AADailyInventoryQuestionTableViewCell : UITableViewCell

@property (strong, nonatomic) InventoryQuestion* question;
@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;

@end