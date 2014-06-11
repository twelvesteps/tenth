//
//  AAContactEmailTableViewCell.m
//  Steps
//
//  Created by tom on 6/11/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAContactEmailTableViewCell.h"

@implementation AAContactEmailTableViewCell

- (IBAction)emailButtonPressed:(UIButton *)sender
{
    [self.delegate emailCell:self buttonWasPressed:sender];
}

@end
