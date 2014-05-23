//
//  Contact.h
//  Steps
//
//  Created by tom on 5/22/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Amend, Email, Phone, Resentment;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isFellow;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSDate * sobrietyDate;
@property (nonatomic, retain) Amend *amend;
@property (nonatomic, retain) Resentment *resentment;
@property (nonatomic, retain) NSSet *phones;
@property (nonatomic, retain) NSSet *emails;
@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addPhonesObject:(Phone *)value;
- (void)removePhonesObject:(Phone *)value;
- (void)addPhones:(NSSet *)values;
- (void)removePhones:(NSSet *)values;

- (void)addEmailsObject:(Email *)value;
- (void)removeEmailsObject:(Email *)value;
- (void)addEmails:(NSSet *)values;
- (void)removeEmails:(NSSet *)values;

@end
