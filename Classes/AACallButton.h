//
//  AACallButton.h
//  Steps
//
//  Created by tom on 5/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface AACallButton : UIButton

@property (weak, nonatomic) UILabel* contactLabel;
@property (strong, nonatomic) Contact* contact;

@end
