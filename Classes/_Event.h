// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Event.h instead.

@import CoreData;
#import "GroupMember.h"

extern const struct EventAttributes {
	__unsafe_unretained NSString *duration;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *title;
} EventAttributes;

@interface EventID : GroupMemberID {}
@end

@interface _Event : GroupMember {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) EventID* objectID;

@property (nonatomic, strong) NSDate* duration;

//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong, readonly) NSString* identifier;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* startDate;

//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@end

@interface _Event (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDuration;
- (void)setPrimitiveDuration:(NSDate*)value;

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

@end
