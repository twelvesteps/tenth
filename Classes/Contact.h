//
//  Contact.h
//  Steps
//
//  Created by tom on 6/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Amend, Email, Phone, Resentment;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSNumber * contactID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * isFellow;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSDate * sobrietyDate;
@property (nonatomic, retain) NSString * abFirstName;
@property (nonatomic, retain) NSString * abLastName;
@property (nonatomic, retain) Amend *amend;
@property (nonatomic, retain) NSSet *emails;
@property (nonatomic, retain) NSSet *phones;
@property (nonatomic, retain) Resentment *resentment;
@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addEmailsObject:(Email *)value;
- (void)removeEmailsObject:(Email *)value;
- (void)addEmails:(NSSet *)values;
- (void)removeEmails:(NSSet *)values;

- (void)addPhonesObject:(Phone *)value;
- (void)removePhonesObject:(Phone *)value;
- (void)addPhones:(NSSet *)values;
- (void)removePhones:(NSSet *)values;

@end
