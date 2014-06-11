//
//  AACallButton.m
//  Steps
//
//  Created by tom on 5/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AACallButton.h"
#import "UIColor-Expanded.h"

@implementation AACallButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone_btn"]];
        CGPoint phoneImageCenter = phoneImageView.center;
        phoneImageCenter.x = self.bounds.origin.x + 22.0f;
        phoneImageCenter.y = self.bounds.origin.y / 2;
        phoneImageView.center = phoneImageCenter;
    }
    return self;
}

@end
