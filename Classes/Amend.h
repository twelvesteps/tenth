//
//  Amend.h
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DailyInventory, Resentment;

@interface Amend : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * contactID;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * harm;
@property (nonatomic, retain) NSString * amends;
@property (nonatomic, retain) NSData * reminder;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) DailyInventory *inventory;
@property (nonatomic, retain) Resentment *resentment;

@end
