//
//  AAContactEmailTableViewCell.h
//  Steps
//
//  Created by tom on 6/11/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Email+AAAdditions.h"

@class AAContactEmailTableViewCell;
@protocol AAContactEmailTableViewCellDelegate <NSObject>

- (void)emailCell:(AAContactEmailTableViewCell*)cell buttonWasPressed:(UIButton*)button;

@end

@interface AAContactEmailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *accessoryButton;

@property (weak, nonatomic) id<AAContactEmailTableViewCellDelegate> delegate;
@property (strong, nonatomic) Email* email;


@end
