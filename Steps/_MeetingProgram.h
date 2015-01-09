// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MeetingProgram.h instead.

#import <CoreData/CoreData.h>
#import "MeetingDescriptor.h"

extern const struct MeetingProgramAttributes {
	__unsafe_unretained NSString *shortTitle;
	__unsafe_unretained NSString *symbolType;
} MeetingProgramAttributes;

extern const struct MeetingProgramRelationships {
	__unsafe_unretained NSString *meetings;
} MeetingProgramRelationships;

@class Meeting;

@interface MeetingProgramID : MeetingDescriptorID {}
@end

@interface _MeetingProgram : MeetingDescriptor {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MeetingProgramID* objectID;

@property (nonatomic, strong) NSString* shortTitle;

//- (BOOL)validateShortTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* symbolType;

@property (atomic) int32_t symbolTypeValue;
- (int32_t)symbolTypeValue;
- (void)setSymbolTypeValue:(int32_t)value_;

//- (BOOL)validateSymbolType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *meetings;

- (NSMutableSet*)meetingsSet;

@end

@interface _MeetingProgram (MeetingsCoreDataGeneratedAccessors)
- (void)addMeetings:(NSSet*)value_;
- (void)removeMeetings:(NSSet*)value_;
- (void)addMeetingsObject:(Meeting*)value_;
- (void)removeMeetingsObject:(Meeting*)value_;

@end

@interface _MeetingProgram (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveShortTitle;
- (void)setPrimitiveShortTitle:(NSString*)value;

- (NSNumber*)primitiveSymbolType;
- (void)setPrimitiveSymbolType:(NSNumber*)value;

- (int32_t)primitiveSymbolTypeValue;
- (void)setPrimitiveSymbolTypeValue:(int32_t)value_;

- (NSMutableSet*)primitiveMeetings;
- (void)setPrimitiveMeetings:(NSMutableSet*)value;

@end
