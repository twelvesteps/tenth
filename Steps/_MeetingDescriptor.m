// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MeetingDescriptor.m instead.

#import "_MeetingDescriptor.h"

const struct MeetingDescriptorAttributes MeetingDescriptorAttributes = {
	.identifier = @"identifier",
	.localizeTitle = @"localizeTitle",
	.title = @"title",
};

@implementation MeetingDescriptorID
@end

@implementation _MeetingDescriptor

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MeetingDescriptor" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MeetingDescriptor";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MeetingDescriptor" inManagedObjectContext:moc_];
}

- (MeetingDescriptorID*)objectID {
	return (MeetingDescriptorID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"localizeTitleValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"localizeTitle"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic identifier;

@dynamic localizeTitle;

- (BOOL)localizeTitleValue {
	NSNumber *result = [self localizeTitle];
	return [result boolValue];
}

- (BOOL)primitiveLocalizeTitleValue {
	NSNumber *result = [self primitiveLocalizeTitle];
	return [result boolValue];
}

- (void)setPrimitiveLocalizeTitleValue:(BOOL)value_ {
	[self setPrimitiveLocalizeTitle:[NSNumber numberWithBool:value_]];
}

@dynamic title;

@end

