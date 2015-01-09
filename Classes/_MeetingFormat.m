// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MeetingFormat.m instead.

#import "_MeetingFormat.h"

const struct MeetingFormatAttributes MeetingFormatAttributes = {
	.colorKey = @"colorKey",
};

const struct MeetingFormatRelationships MeetingFormatRelationships = {
	.meetings = @"meetings",
};

@implementation MeetingFormatID
@end

@implementation _MeetingFormat

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MeetingFormat" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MeetingFormat";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MeetingFormat" inManagedObjectContext:moc_];
}

- (MeetingFormatID*)objectID {
	return (MeetingFormatID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic colorKey;

@dynamic meetings;

- (NSMutableSet*)meetingsSet {
	[self willAccessValueForKey:@"meetings"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"meetings"];

	[self didAccessValueForKey:@"meetings"];
	return result;
}

@end

