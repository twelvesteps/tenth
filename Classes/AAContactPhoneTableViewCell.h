//
//  AAContactPhoneAndEmailTableViewCell.h
//  Steps
//
//  Created by tom on 5/28/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone+AAAdditions.h"

typedef NS_ENUM(NSUInteger, AAPhoneCellAction) {
    AAPhoneCellActionCall,
    AAPhoneCellActionMessage,
};

@class AAContactPhoneTableViewCell;
@protocol AAContactPhoneTableViewCellDelegate <NSObject>

- (void)phoneCell:(AAContactPhoneTableViewCell*)cell buttonWasPressed:(UIButton*)button;

@end

@interface AAContactPhoneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UIButton* messageButton;

@property (weak, nonatomic) id<AAContactPhoneTableViewCellDelegate> delegate;
@property (strong, nonatomic) Phone* phone;

@end
