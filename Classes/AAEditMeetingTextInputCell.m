//
//  AAEditMeetingTextInputCell.m
//  Steps
//
//  Created by Tom on 11/29/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingTextInputCell.h"
#import "UIFont+AAAdditions.h"
#import "UIColor+AAAdditions.h"

@interface AAEditMeetingTextInputCell()

@end

@implementation AAEditMeetingTextInputCell

#define SEPARATOR_VIEW_HEIGHT   0.5f
#define CELL_HEIGHT             44.0f

- (void)awakeFromNib
{    
    [super awakeFromNib];
    
    self.textField.font = [UIFont stepsCaptionFont];

}

@end
