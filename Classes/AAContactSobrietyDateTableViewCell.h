//
//  AAContactSobrietyDateTableViewCell.h
//  Steps
//
//  Created by tom on 6/12/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AASeparatorTableViewCell.h"

@interface AAContactSobrietyDateTableViewCell : AASeparatorTableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;

@end
