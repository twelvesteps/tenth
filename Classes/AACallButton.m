//
//  AACallButton.m
//  Steps
//
//  Created by tom on 5/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AACallButton.h"

@implementation AACallButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel* contactLabel = [[UILabel alloc] initWithFrame:[self getLabelRect]];
        [self addSubview:contactLabel];
        self.contactLabel = contactLabel;
        self.contactLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)getLabelRect
{
    return CGRectMake(self.bounds.origin.x + 10.0f,
                      self.bounds.origin.y + 10.0f,
                      self.bounds.size.width - 20.0f,
                      self.bounds.size.height - 20.0f);
}


- (void)drawRect:(CGRect)rect
{
    [[UIColor greenColor] setFill];
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [path fill];
}

@end
