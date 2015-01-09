// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Phone.m instead.

#import "_Phone.h"

const struct PhoneAttributes PhoneAttributes = {
	.number = @"number",
	.title = @"title",
};

const struct PhoneRelationships PhoneRelationships = {
	.contact = @"contact",
};

@implementation PhoneID
@end

@implementation _Phone

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Phone" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Phone";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Phone" inManagedObjectContext:moc_];
}

- (PhoneID*)objectID {
	return (PhoneID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic number;

@dynamic title;

@dynamic contact;

@end

