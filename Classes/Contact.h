//
//  Contact.h
//  Steps
//
//  Created by Tom on 11/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Email, Phone;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * abFirstName;
@property (nonatomic, retain) NSString * abLastName;
@property (nonatomic, retain) NSNumber * contactID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * isSponsor;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * needsABLink;
@property (nonatomic, retain) NSDate * sobrietyDate;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSSet *emails;
@property (nonatomic, retain) NSSet *phones;
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
