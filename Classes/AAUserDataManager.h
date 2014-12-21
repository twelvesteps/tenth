//
//  AAUserDataManager.h
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AAUserDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

// *** FETCHING ITEMS ***
/**
 *  Fetches all items with the given entity name matching the given predicate
 *  and sorts them according to the sort descriptors. Should only be called
 *  by subclasses of AAUserDataManager.
 *
 *  @param name        Name of the entity to be fetched
 *  @param descriptors Descriptors describing how to sort the fetched entities.
 *  @param predicate   Predicate for filtering the fetch results.
 *
 *  @return Array of entities matching the given predicate in the prescribed sort order.
 */
- (NSArray*)fetchItemsForEntityName:(NSString*)name
                withSortDescriptors:(NSArray*)descriptors
                      withPredicate:(NSPredicate*)predicate;

// *** MAINTAINING PERSISTENCE ***
/**
 *  Saves the current state of the object graph to the backing persistent store.
 *
 *  @return YES if save is successful, NO otherwise. Check console for error message
 */
- (BOOL)synchronize;

/**
 *  Saves the current state of the object graph to the backing persistent store and 
 *  clears the current object graph from memory.
 *
 *  @return YES if save and flush were successful, NO otherwise. Check console for error message.
 */
- (BOOL)flush;

@end
