// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FellowshipEntity.m instead.

#import "_FellowshipEntity.h"

const struct FellowshipEntityAttributes FellowshipEntityAttributes = {
	.creationDate = @"creationDate",
	.identifier = @"identifier",
	.modificationDate = @"modificationDate",
};

const struct FellowshipEntityRelationships FellowshipEntityRelationships = {
	.groups = @"groups",
};

@implementation FellowshipEntityID
@end

@implementation _FellowshipEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FellowshipEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FellowshipEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FellowshipEntity" inManagedObjectContext:moc_];
}

- (FellowshipEntityID*)objectID {
	return (FellowshipEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic creationDate;

@dynamic identifier;

@dynamic modificationDate;

@dynamic groups;

- (NSMutableSet*)groupsSet {
	[self willAccessValueForKey:@"groups"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"groups"];

	[self didAccessValueForKey:@"groups"];
	return result;
}

@end

