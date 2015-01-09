// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MeetingFormat.h instead.

@import CoreData;
#import "MeetingDescriptor.h"

extern const struct MeetingFormatAttributes {
	__unsafe_unretained NSString *colorKey;
} MeetingFormatAttributes;

extern const struct MeetingFormatRelationships {
	__unsafe_unretained NSString *meetings;
} MeetingFormatRelationships;

@class Meeting;

@interface MeetingFormatID : MeetingDescriptorID {}
@end

@interface _MeetingFormat : MeetingDescriptor {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MeetingFormatID* objectID;

@property (nonatomic, strong) NSString* colorKey;

//- (BOOL)validateColorKey:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *meetings;

- (NSMutableSet*)meetingsSet;

@end

@interface _MeetingFormat (MeetingsCoreDataGeneratedAccessors)
- (void)addMeetings:(NSSet*)value_;
- (void)removeMeetings:(NSSet*)value_;
- (void)addMeetingsObject:(Meeting*)value_;
- (void)removeMeetingsObject:(Meeting*)value_;

@end

@interface _MeetingFormat (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveColorKey;
- (void)setPrimitiveColorKey:(NSString*)value;

- (NSMutableSet*)primitiveMeetings;
- (void)setPrimitiveMeetings:(NSMutableSet*)value;

@end
