//
//  DailyInventory+AAAdditions.m
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "DailyInventory+AAAdditions.h"
#import "InventoryQuestion+AAAdditions.h"

@implementation DailyInventory (AAAdditions)

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setDate:[NSDate date]];
    
    for (NSUInteger i = 0; i < AA_DAILY_INVENTORY_QUESTION_COUNT; ++i) {
        [self addQuestionsObject:[InventoryQuestion questionForNumber:[NSNumber numberWithInteger:i]]];
    }
}

@end
