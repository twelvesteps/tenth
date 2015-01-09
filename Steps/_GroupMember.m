// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GroupMember.m instead.

#import "_GroupMember.h"

const struct GroupMemberRelationships GroupMemberRelationships = {
	.groups = @"groups",
};

@implementation GroupMemberID
@end

@implementation _GroupMember

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"GroupMember" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"GroupMember";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"GroupMember" inManagedObjectContext:moc_];
}

- (GroupMemberID*)objectID {
	return (GroupMemberID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic groups;

- (NSMutableSet*)groupsSet {
	[self willAccessValueForKey:@"groups"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"groups"];

	[self didAccessValueForKey:@"groups"];
	return result;
}

@end

