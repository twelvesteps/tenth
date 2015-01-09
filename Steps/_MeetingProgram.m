// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MeetingProgram.m instead.

#import "_MeetingProgram.h"

const struct MeetingProgramAttributes MeetingProgramAttributes = {
	.shortTitle = @"shortTitle",
	.symbolType = @"symbolType",
};

const struct MeetingProgramRelationships MeetingProgramRelationships = {
	.meetings = @"meetings",
};

@implementation MeetingProgramID
@end

@implementation _MeetingProgram

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MeetingProgram" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MeetingProgram";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MeetingProgram" inManagedObjectContext:moc_];
}

- (MeetingProgramID*)objectID {
	return (MeetingProgramID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"symbolTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"symbolType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic shortTitle;

@dynamic symbolType;

- (int32_t)symbolTypeValue {
	NSNumber *result = [self symbolType];
	return [result intValue];
}

- (void)setSymbolTypeValue:(int32_t)value_ {
	[self setSymbolType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveSymbolTypeValue {
	NSNumber *result = [self primitiveSymbolType];
	return [result intValue];
}

- (void)setPrimitiveSymbolTypeValue:(int32_t)value_ {
	[self setPrimitiveSymbolType:[NSNumber numberWithInt:value_]];
}

@dynamic meetings;

- (NSMutableSet*)meetingsSet {
	[self willAccessValueForKey:@"meetings"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"meetings"];

	[self didAccessValueForKey:@"meetings"];
	return result;
}

@end

