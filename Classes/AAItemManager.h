//
//  AAItemManager.h
//  Steps
//
//  Created by Tom on 5/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAStepItem.h"

typedef NS_ENUM(NSInteger, AAStepItemsFileAccessResult) {
    AAStepItemsFileAccessError = 0,
    AAStepItemsFileAccessSuccess = 1,
};

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


// MODIFYING DATA
// info:    Updates the item managers data for the given step
// returns: void
// use:     [manager updateStepItemsForStep:[item stepNumber] withItems:modifiedItems];
- (void)updateStepItemsForStep:(NSUInteger)step withItems:(NSArray*)items;


// PERSISTENCE
// info:    Updates the persistent store to reflect current state.
// returns: AAStepItemsFileAccessResult indicating success or error
// use:     AAStepItemsFileAccessResult result = [manager synchronize];
- (void)synchronize;

// info:    Releases memory objects and commits the current state to file.
// returns: AAStepItemsFileAccessResult indicating success or error
// use:     AAStepItesmFileAccessResult result = [manager flush];
- (void)flush;

@end
