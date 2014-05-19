//
//  Resentment.h
//  Steps
//
//  Created by tom on 5/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Amend, Contact, DailyInventory;

@interface Resentment : NSManagedObject

@property (nonatomic, retain) NSNumber * contactID;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * effects;
@property (nonatomic, retain) NSSet *amends;
@property (nonatomic, retain) DailyInventory *inventory;
@property (nonatomic, retain) Contact *contact;
@end

@interface Resentment (CoreDataGeneratedAccessors)

- (void)addAmendsObject:(Amend *)value;
- (void)removeAmendsObject:(Amend *)value;
- (void)addAmends:(NSSet *)values;
- (void)removeAmends:(NSSet *)values;

@end
