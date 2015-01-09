// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Meeting.h instead.

#import <CoreData/CoreData.h>
#import "Event.h"

extern const struct MeetingAttributes {
	__unsafe_unretained NSString *isOpen;
	__unsafe_unretained NSString *literature;
} MeetingAttributes;

extern const struct MeetingRelationships {
	__unsafe_unretained NSString *formats;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *program;
} MeetingRelationships;

@class MeetingFormat;
@class Location;
@class MeetingProgram;

@interface MeetingID : EventID {}
@end

@interface _Meeting : Event {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MeetingID* objectID;

@property (nonatomic, strong) NSNumber* isOpen;

@property (atomic) BOOL isOpenValue;
- (BOOL)isOpenValue;
- (void)setIsOpenValue:(BOOL)value_;

//- (BOOL)validateIsOpen:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* literature;

//- (BOOL)validateLiterature:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *formats;

- (NSMutableSet*)formatsSet;

@property (nonatomic, strong) Location *location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MeetingProgram *program;

//- (BOOL)validateProgram:(id*)value_ error:(NSError**)error_;

@end

@interface _Meeting (FormatsCoreDataGeneratedAccessors)
- (void)addFormats:(NSSet*)value_;
- (void)removeFormats:(NSSet*)value_;
- (void)addFormatsObject:(MeetingFormat*)value_;
- (void)removeFormatsObject:(MeetingFormat*)value_;

@end

@interface _Meeting (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIsOpen;
- (void)setPrimitiveIsOpen:(NSNumber*)value;

- (BOOL)primitiveIsOpenValue;
- (void)setPrimitiveIsOpenValue:(BOOL)value_;

- (NSString*)primitiveLiterature;
- (void)setPrimitiveLiterature:(NSString*)value;

- (NSMutableSet*)primitiveFormats;
- (void)setPrimitiveFormats:(NSMutableSet*)value;

- (Location*)primitiveLocation;
- (void)setPrimitiveLocation:(Location*)value;

- (MeetingProgram*)primitiveProgram;
- (void)setPrimitiveProgram:(MeetingProgram*)value;

@end
