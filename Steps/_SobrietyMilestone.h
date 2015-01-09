// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SobrietyMilestone.h instead.

#import <CoreData/CoreData.h>
#import "Event.h"

extern const struct SobrietyMilestoneAttributes {
	__unsafe_unretained NSString *chipColor;
	__unsafe_unretained NSString *sobrietyLength;
} SobrietyMilestoneAttributes;

extern const struct SobrietyMilestoneRelationships {
	__unsafe_unretained NSString *contact;
} SobrietyMilestoneRelationships;

@class Contact;

@interface SobrietyMilestoneID : EventID {}
@end

@interface _SobrietyMilestone : Event {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SobrietyMilestoneID* objectID;

@property (nonatomic, strong) NSString* chipColor;

//- (BOOL)validateChipColor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* sobrietyLength;

//- (BOOL)validateSobrietyLength:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Contact *contact;

//- (BOOL)validateContact:(id*)value_ error:(NSError**)error_;

@end

@interface _SobrietyMilestone (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveChipColor;
- (void)setPrimitiveChipColor:(NSString*)value;

- (NSDate*)primitiveSobrietyLength;
- (void)setPrimitiveSobrietyLength:(NSDate*)value;

- (Contact*)primitiveContact;
- (void)setPrimitiveContact:(Contact*)value;

@end
