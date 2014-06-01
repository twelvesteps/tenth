//
//  AAEditContactNameAndImageTableViewCell.h
//  Steps
//
//  Created by tom on 6/2/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAEditContactNameAndImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UIButton *editContactImageButton;
@property (weak, nonatomic) IBOutlet UITextField *contactFirstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactLastNameTextField;


@end
