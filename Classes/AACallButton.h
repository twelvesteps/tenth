//
//  AACallButton.h
//  Steps
//
//  Created by tom on 5/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone+AAAdditions.h"
@interface AACallButton : UIButton

@property (weak, nonatomic) UILabel* nameLabel;
@property (weak, nonatomic) UILabel* descriptionLabel;
@property (strong, nonatomic) Phone* phone;

@end
