//
//  Amend.h
//  Steps
//
//  Created by tom on 5/22/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, DailyInventory, Resentment;

@interface Amend : NSManagedObject

@property (nonatomic, retain) NSString * amends;
@property (nonatomic, retain) NSNumber * contactID;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * harm;
@property (nonatomic, retain) NSData * reminder;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) DailyInventory *inventory;
@property (nonatomic, retain) Resentment *resentment;

@end
