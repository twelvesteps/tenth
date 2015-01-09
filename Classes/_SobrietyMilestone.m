// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SobrietyMilestone.m instead.

#import "_SobrietyMilestone.h"

const struct SobrietyMilestoneAttributes SobrietyMilestoneAttributes = {
	.chipColor = @"chipColor",
	.sobrietyLength = @"sobrietyLength",
};

const struct SobrietyMilestoneRelationships SobrietyMilestoneRelationships = {
	.contact = @"contact",
};

@implementation SobrietyMilestoneID
@end

@implementation _SobrietyMilestone

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SobrietyMilestone" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SobrietyMilestone";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SobrietyMilestone" inManagedObjectContext:moc_];
}

- (SobrietyMilestoneID*)objectID {
	return (SobrietyMilestoneID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic chipColor;

@dynamic sobrietyLength;

@dynamic contact;

@end

