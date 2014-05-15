//
//  InventoryQuestion.h
//  Steps
//
//  Created by Tom on 5/14/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DailyInventory;

@interface InventoryQuestion : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * yesNoAnswer;
@property (nonatomic, retain) NSString * descriptiveAnswer;
@property (nonatomic, retain) DailyInventory *inventory;

@end
