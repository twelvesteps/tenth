// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GroupMember.h instead.

@import CoreData;
#import "Entity.h"

extern const struct GroupMemberRelationships {
	__unsafe_unretained NSString *groups;
} GroupMemberRelationships;

@class Group;

@interface GroupMemberID : EntityID {}
@end

@interface _GroupMember : Entity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) GroupMemberID* objectID;

@property (nonatomic, strong) NSSet *groups;

- (NSMutableSet*)groupsSet;

@end

@interface _GroupMember (GroupsCoreDataGeneratedAccessors)
- (void)addGroups:(NSSet*)value_;
- (void)removeGroups:(NSSet*)value_;
- (void)addGroupsObject:(Group*)value_;
- (void)removeGroupsObject:(Group*)value_;

@end

@interface _GroupMember (CoreDataGeneratedPrimitiveAccessors)

- (NSMutableSet*)primitiveGroups;
- (void)setPrimitiveGroups:(NSMutableSet*)value;

@end
