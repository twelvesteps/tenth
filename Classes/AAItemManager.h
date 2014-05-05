//
//  AAItemManager.h
//  Steps
//
//  Created by Tom on 5/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAStepItem.h"

@interface AAItemManager : NSObject

// CREATING
// info:    The default manager shared by all controllers.
// returns: AAItemManager instance on success, nil on failure.
// use:     AAItemManager* manager = [AAItemManager sharedItemManager];
+ (AAItemManager*)sharedItemManager;


// ACCESSING DATA
// info:    All AAStepItems for a given step.
// returns; A possibly empty NSArray on success, or nil on failure.
// use:     NSArray* tenthStepItems = [manager getItemsForStep:10];
- (NSArray*)getItemsForStep:(NSUInteger)step;

// info:    All AAStepItems modified after a given date.
// returns: A possibly empty NSArray on success, nil on failure.
// use:     NSArray* recentItems = [manager getItemsSinceDate:[NSDate dateWithTimeIntervalSinceNow:-86400]];
- (NSArray*)getItemsSinceDate:(NSUInteger)date;


// MODIFYING DATA
// info:    Modifies the given item within AAItemManager's memory (non-persistent).
// returns: 1 on success, 0 on item not found, -1 on failure.
// use:     NSInteger result = [manager modifyItem:modifiedItem];
- (NSInteger)modifyItem:(AAStepItem*)item;

// info:    Adds the given item to AAItemManager's memory (non-persistent).
// returns: 1 on success, -1 on failure.
// use:     NSInteger result = [manager addItem:newItem];
- (NSInteger)addItem:(AAStepItem*)item;

// info:    Removes the given item from AAItemManager's memory (non-persistent)
// returns: 1 on success, 0 on item not found, -1 on failure.
// use:     NSInteger result = [manager removeItem];
- (NSInteger)removeItem:(AAStepItem*)item;


// PERSISTENCE
// info:    Updates the persistent store to reflect current state (thread-safe).
// returns: 1 on success, -1 on failure
// use:     NSInteger result = [manager synchronize];
- (void)synchronize;

@end
