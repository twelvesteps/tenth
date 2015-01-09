// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.h instead.

@import CoreData;
#import "Entity.h"

extern const struct GroupAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *title;
} GroupAttributes;

extern const struct GroupRelationships {
	__unsafe_unretained NSString *members;
} GroupRelationships;

@class GroupMember;

@interface GroupID : EntityID {}
@end

@interface _Group : Entity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) GroupID* objectID;

@property (nonatomic, strong, readonly) NSString* identifier;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *members;

- (NSMutableSet*)membersSet;

@end

@interface _Group (MembersCoreDataGeneratedAccessors)
- (void)addMembers:(NSSet*)value_;
- (void)removeMembers:(NSSet*)value_;
- (void)addMembersObject:(GroupMember*)value_;
- (void)removeMembersObject:(GroupMember*)value_;

@end

@interface _Group (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSMutableSet*)primitiveMembers;
- (void)setPrimitiveMembers:(NSMutableSet*)value;

@end
