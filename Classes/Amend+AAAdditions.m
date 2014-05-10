//
//  Amend+AAAdditions.m
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "Amend+AAAdditions.h"

@implementation Amend (AAAdditions)

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setCreationDate:[NSDate date]];
}

@end
