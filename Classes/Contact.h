//
//  Contact.h
//  Steps
//
//  Created by tom on 5/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Amend, Resentment;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * sobrietyDate;
@property (nonatomic, retain) NSNumber * isFellow;
@property (nonatomic, retain) Amend *amend;
@property (nonatomic, retain) Resentment *resentment;

@end
