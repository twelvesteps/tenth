//
//  DailyInventory+AAAdditions.m
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "DailyInventory+AAAdditions.h"

@implementation DailyInventory (AAAdditions)

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setDate:[NSDate date]];
}

@end
