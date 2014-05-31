//
//  AANoAnimationSegue.m
//  Steps
//
//  Created by tom on 5/31/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AANoAnimationSegue.h"

@implementation AANoAnimationSegue

- (void)perform
{
    [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
}

@end
