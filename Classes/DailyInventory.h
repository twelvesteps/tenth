//
//  DailyInventory.h
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Amend, Resentment;

@interface DailyInventory : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * answers;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSSet *amends;
@property (nonatomic, retain) NSSet *resentment;
@end

@interface DailyInventory (CoreDataGeneratedAccessors)

- (void)addAmendsObject:(Amend *)value;
- (void)removeAmendsObject:(Amend *)value;
- (void)addAmends:(NSSet *)values;
- (void)removeAmends:(NSSet *)values;

- (void)addResentmentObject:(Resentment *)value;
- (void)removeResentmentObject:(Resentment *)value;
- (void)addResentment:(NSSet *)values;
- (void)removeResentment:(NSSet *)values;

@end
