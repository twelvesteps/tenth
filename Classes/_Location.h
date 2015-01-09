// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Location.h instead.

@import CoreData;
#import "MeetingDescriptor.h"

extern const struct LocationAttributes {
	__unsafe_unretained NSString *country;
	__unsafe_unretained NSString *locality;
	__unsafe_unretained NSString *postalCode;
	__unsafe_unretained NSString *region;
	__unsafe_unretained NSString *street;
} LocationAttributes;

extern const struct LocationRelationships {
	__unsafe_unretained NSString *meetings;
} LocationRelationships;

@class Meeting;

@interface LocationID : MeetingDescriptorID {}
@end

@interface _Location : MeetingDescriptor {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) LocationID* objectID;

@property (nonatomic, strong) NSString* country;

//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* locality;

//- (BOOL)validateLocality:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* postalCode;

//- (BOOL)validatePostalCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* region;

//- (BOOL)validateRegion:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* street;

//- (BOOL)validateStreet:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Meeting *meetings;

//- (BOOL)validateMeetings:(id*)value_ error:(NSError**)error_;

@end

@interface _Location (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;

- (NSString*)primitiveLocality;
- (void)setPrimitiveLocality:(NSString*)value;

- (NSString*)primitivePostalCode;
- (void)setPrimitivePostalCode:(NSString*)value;

- (NSString*)primitiveRegion;
- (void)setPrimitiveRegion:(NSString*)value;

- (NSString*)primitiveStreet;
- (void)setPrimitiveStreet:(NSString*)value;

- (Meeting*)primitiveMeetings;
- (void)setPrimitiveMeetings:(Meeting*)value;

@end
