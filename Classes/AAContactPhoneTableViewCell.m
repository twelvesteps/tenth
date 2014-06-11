//
//  AAContactPhoneAndEmailTableViewCell.m
//  Steps
//
//  Created by tom on 5/28/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAContactPhoneTableViewCell.h"

@implementation AAContactPhoneTableViewCell

- (IBAction)messageButtonTapped:(UIButton*)sender
{
    [self.delegate phoneCell:self buttonWasPressed:sender];
}

@end
