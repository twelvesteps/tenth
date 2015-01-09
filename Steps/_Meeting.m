// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Meeting.m instead.

#import "_Meeting.h"

const struct MeetingAttributes MeetingAttributes = {
	.isOpen = @"isOpen",
	.literature = @"literature",
};

const struct MeetingRelationships MeetingRelationships = {
	.formats = @"formats",
	.location = @"location",
	.program = @"program",
};

@implementation MeetingID
@end

@implementation _Meeting

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Meeting" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Meeting";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Meeting" inManagedObjectContext:moc_];
}

- (MeetingID*)objectID {
	return (MeetingID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isOpenValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isOpen"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic isOpen;

- (BOOL)isOpenValue {
	NSNumber *result = [self isOpen];
	return [result boolValue];
}

- (void)setIsOpenValue:(BOOL)value_ {
	[self setIsOpen:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsOpenValue {
	NSNumber *result = [self primitiveIsOpen];
	return [result boolValue];
}

- (void)setPrimitiveIsOpenValue:(BOOL)value_ {
	[self setPrimitiveIsOpen:[NSNumber numberWithBool:value_]];
}

@dynamic literature;

@dynamic formats;

- (NSMutableSet*)formatsSet {
	[self willAccessValueForKey:@"formats"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"formats"];

	[self didAccessValueForKey:@"formats"];
	return result;
}

@dynamic location;

@dynamic program;

@end

