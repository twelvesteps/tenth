//
//  AADailyInventoryQuestionShortTableViewCell.m
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AADailyInventoryQuestionShortTableViewCell.h"
@interface AADailyInventoryQuestionShortTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;
@property (weak, nonatomic) IBOutlet UISwitch *yesNoSwitch;


@end

@implementation AADailyInventoryQuestionShortTableViewCell

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
