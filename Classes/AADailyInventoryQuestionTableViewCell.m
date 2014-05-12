//
//  AADailyInventoryQuestionTableViewCell.m
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AADailyInventoryQuestionTableViewCell.h"

@implementation AADailyInventoryQuestionTableViewCell

- (void)setQuestion:(AADailyInventoryQuestion *)question
{
    _question = question;
    if (_question) {
        self.questionTextLabel.text = question.questionText;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
