// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MeetingDescriptor.h instead.

#import <CoreData/CoreData.h>

extern const struct MeetingDescriptorAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *localizeTitle;
	__unsafe_unretained NSString *title;
} MeetingDescriptorAttributes;

@interface MeetingDescriptorID : NSManagedObjectID {}
@end

@interface _MeetingDescriptor : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MeetingDescriptorID* objectID;

@property (nonatomic, strong, readonly) NSString* identifier;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong, readonly) NSNumber* localizeTitle;

@property (atomic, readonly) BOOL localizeTitleValue;
- (BOOL)localizeTitleValue;

//- (BOOL)validateLocalizeTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@end

@interface _MeetingDescriptor (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

- (NSNumber*)primitiveLocalizeTitle;
- (void)setPrimitiveLocalizeTitle:(NSNumber*)value;

- (BOOL)primitiveLocalizeTitleValue;
- (void)setPrimitiveLocalizeTitleValue:(BOOL)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

@end
