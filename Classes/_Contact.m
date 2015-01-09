// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Contact.m instead.

#import "_Contact.h"

const struct ContactAttributes ContactAttributes = {
	.abFirstName = @"abFirstName",
	.abLastName = @"abLastName",
	.contactID = @"contactID",
	.firstName = @"firstName",
	.image = @"image",
	.isSponsor = @"isSponsor",
	.lastName = @"lastName",
	.needsABLink = @"needsABLink",
	.sobrietyDate = @"sobrietyDate",
};

const struct ContactRelationships ContactRelationships = {
	.emails = @"emails",
	.milestones = @"milestones",
	.phones = @"phones",
};

@implementation ContactID
@end

@implementation _Contact

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Contact";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:moc_];
}

- (ContactID*)objectID {
	return (ContactID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"contactIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"contactID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isSponsorValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isSponsor"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"needsABLinkValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"needsABLink"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic abFirstName;

@dynamic abLastName;

@dynamic contactID;

- (int32_t)contactIDValue {
	NSNumber *result = [self contactID];
	return [result intValue];
}

- (void)setContactIDValue:(int32_t)value_ {
	[self setContactID:@(value_)];
}

- (int32_t)primitiveContactIDValue {
	NSNumber *result = [self primitiveContactID];
	return [result intValue];
}

- (void)setPrimitiveContactIDValue:(int32_t)value_ {
	[self setPrimitiveContactID:@(value_)];
}

@dynamic firstName;

@dynamic image;

@dynamic isSponsor;

- (BOOL)isSponsorValue {
	NSNumber *result = [self isSponsor];
	return [result boolValue];
}

- (void)setIsSponsorValue:(BOOL)value_ {
	[self setIsSponsor:@(value_)];
}

- (BOOL)primitiveIsSponsorValue {
	NSNumber *result = [self primitiveIsSponsor];
	return [result boolValue];
}

- (void)setPrimitiveIsSponsorValue:(BOOL)value_ {
	[self setPrimitiveIsSponsor:@(value_)];
}

@dynamic lastName;

@dynamic needsABLink;

- (BOOL)needsABLinkValue {
	NSNumber *result = [self needsABLink];
	return [result boolValue];
}

- (void)setNeedsABLinkValue:(BOOL)value_ {
	[self setNeedsABLink:@(value_)];
}

- (BOOL)primitiveNeedsABLinkValue {
	NSNumber *result = [self primitiveNeedsABLink];
	return [result boolValue];
}

- (void)setPrimitiveNeedsABLinkValue:(BOOL)value_ {
	[self setPrimitiveNeedsABLink:@(value_)];
}

@dynamic sobrietyDate;

@dynamic emails;

- (NSMutableSet*)emailsSet {
	[self willAccessValueForKey:@"emails"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"emails"];

	[self didAccessValueForKey:@"emails"];
	return result;
}

@dynamic milestones;

- (NSMutableSet*)milestonesSet {
	[self willAccessValueForKey:@"milestones"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"milestones"];

	[self didAccessValueForKey:@"milestones"];
	return result;
}

@dynamic phones;

- (NSMutableSet*)phonesSet {
	[self willAccessValueForKey:@"phones"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"phones"];

	[self didAccessValueForKey:@"phones"];
	return result;
}

@end

