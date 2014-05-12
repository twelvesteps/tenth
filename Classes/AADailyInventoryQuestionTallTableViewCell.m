//
//  AADailyInventoryQuestionTallTableViewCell.m
//  Steps
//
//  Created by Tom on 5/11/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AADailyInventoryQuestionTallTableViewCell.h"

@interface AADailyInventoryQuestionTallTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;
@property (weak, nonatomic) IBOutlet UISwitch *yesNoSwitch;

@end

@implementation AADailyInventoryQuestionTallTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
