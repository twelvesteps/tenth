// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Contact.h instead.

#import <CoreData/CoreData.h>
#import "GroupMember.h"

extern const struct ContactAttributes {
	__unsafe_unretained NSString *abFirstName;
	__unsafe_unretained NSString *abLastName;
	__unsafe_unretained NSString *contactID;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *isSponsor;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *needsABLink;
	__unsafe_unretained NSString *sobrietyDate;
} ContactAttributes;

extern const struct ContactRelationships {
	__unsafe_unretained NSString *emails;
	__unsafe_unretained NSString *milestones;
	__unsafe_unretained NSString *phones;
} ContactRelationships;

@class Email;
@class SobrietyMilestone;
@class Phone;

@interface ContactID : GroupMemberID {}
@end

@interface _Contact : GroupMember {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ContactID* objectID;

@property (nonatomic, strong) NSString* abFirstName;

//- (BOOL)validateAbFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* abLastName;

//- (BOOL)validateAbLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* contactID;

@property (atomic) int32_t contactIDValue;
- (int32_t)contactIDValue;
- (void)setContactIDValue:(int32_t)value_;

//- (BOOL)validateContactID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isSponsor;

@property (atomic) BOOL isSponsorValue;
- (BOOL)isSponsorValue;
- (void)setIsSponsorValue:(BOOL)value_;

//- (BOOL)validateIsSponsor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* needsABLink;

@property (atomic) BOOL needsABLinkValue;
- (BOOL)needsABLinkValue;
- (void)setNeedsABLinkValue:(BOOL)value_;

//- (BOOL)validateNeedsABLink:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* sobrietyDate;

//- (BOOL)validateSobrietyDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *emails;

- (NSMutableSet*)emailsSet;

@property (nonatomic, strong) NSSet *milestones;

- (NSMutableSet*)milestonesSet;

@property (nonatomic, strong) NSSet *phones;

- (NSMutableSet*)phonesSet;

@end

@interface _Contact (EmailsCoreDataGeneratedAccessors)
- (void)addEmails:(NSSet*)value_;
- (void)removeEmails:(NSSet*)value_;
- (void)addEmailsObject:(Email*)value_;
- (void)removeEmailsObject:(Email*)value_;

@end

@interface _Contact (MilestonesCoreDataGeneratedAccessors)
- (void)addMilestones:(NSSet*)value_;
- (void)removeMilestones:(NSSet*)value_;
- (void)addMilestonesObject:(SobrietyMilestone*)value_;
- (void)removeMilestonesObject:(SobrietyMilestone*)value_;

@end

@interface _Contact (PhonesCoreDataGeneratedAccessors)
- (void)addPhones:(NSSet*)value_;
- (void)removePhones:(NSSet*)value_;
- (void)addPhonesObject:(Phone*)value_;
- (void)removePhonesObject:(Phone*)value_;

@end

@interface _Contact (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAbFirstName;
- (void)setPrimitiveAbFirstName:(NSString*)value;

- (NSString*)primitiveAbLastName;
- (void)setPrimitiveAbLastName:(NSString*)value;

- (NSNumber*)primitiveContactID;
- (void)setPrimitiveContactID:(NSNumber*)value;

- (int32_t)primitiveContactIDValue;
- (void)setPrimitiveContactIDValue:(int32_t)value_;

- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;

- (NSData*)primitiveImage;
- (void)setPrimitiveImage:(NSData*)value;

- (NSNumber*)primitiveIsSponsor;
- (void)setPrimitiveIsSponsor:(NSNumber*)value;

- (BOOL)primitiveIsSponsorValue;
- (void)setPrimitiveIsSponsorValue:(BOOL)value_;

- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;

- (NSNumber*)primitiveNeedsABLink;
- (void)setPrimitiveNeedsABLink:(NSNumber*)value;

- (BOOL)primitiveNeedsABLinkValue;
- (void)setPrimitiveNeedsABLinkValue:(BOOL)value_;

- (NSDate*)primitiveSobrietyDate;
- (void)setPrimitiveSobrietyDate:(NSDate*)value;

- (NSMutableSet*)primitiveEmails;
- (void)setPrimitiveEmails:(NSMutableSet*)value;

- (NSMutableSet*)primitiveMilestones;
- (void)setPrimitiveMilestones:(NSMutableSet*)value;

- (NSMutableSet*)primitivePhones;
- (void)setPrimitivePhones:(NSMutableSet*)value;

@end
