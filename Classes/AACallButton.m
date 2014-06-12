//
//  AACallButton.m
//  Steps
//
//  Created by tom on 5/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AACallButton.h"
@interface AACallButton ()

@property (nonatomic) BOOL imageAdded;

@end

@implementation AACallButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    if (!_imageAdded) {
        UIImageView* phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone_btn.png"]];
        CGPoint phoneImageCenter = phoneImageView.center;
        phoneImageCenter.x = self.bounds.origin.x + 22.0f;
        phoneImageCenter.y = self.bounds.origin.y / 2;
        phoneImageView.center = phoneImageCenter;
        [self addSubview:phoneImageView];
    }
}

@end
