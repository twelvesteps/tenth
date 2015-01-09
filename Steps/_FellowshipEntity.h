// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FellowshipEntity.h instead.

#import <CoreData/CoreData.h>

extern const struct FellowshipEntityAttributes {
	__unsafe_unretained NSString *creationDate;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *modificationDate;
} FellowshipEntityAttributes;

extern const struct FellowshipEntityRelationships {
	__unsafe_unretained NSString *groups;
} FellowshipEntityRelationships;

@class Group;

@interface FellowshipEntityID : NSManagedObjectID {}
@end

@interface _FellowshipEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FellowshipEntityID* objectID;

@property (nonatomic, strong) NSDate* creationDate;

//- (BOOL)validateCreationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong, readonly) NSString* identifier;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* modificationDate;

//- (BOOL)validateModificationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *groups;

- (NSMutableSet*)groupsSet;

@end

@interface _FellowshipEntity (GroupsCoreDataGeneratedAccessors)
- (void)addGroups:(NSSet*)value_;
- (void)removeGroups:(NSSet*)value_;
- (void)addGroupsObject:(Group*)value_;
- (void)removeGroupsObject:(Group*)value_;

@end

@interface _FellowshipEntity (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreationDate;
- (void)setPrimitiveCreationDate:(NSDate*)value;

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

- (NSDate*)primitiveModificationDate;
- (void)setPrimitiveModificationDate:(NSDate*)value;

- (NSMutableSet*)primitiveGroups;
- (void)setPrimitiveGroups:(NSMutableSet*)value;

@end
