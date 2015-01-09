// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Phone.h instead.

@import CoreData;

extern const struct PhoneAttributes {
	__unsafe_unretained NSString *number;
	__unsafe_unretained NSString *title;
} PhoneAttributes;

extern const struct PhoneRelationships {
	__unsafe_unretained NSString *contact;
} PhoneRelationships;

@class Contact;

@interface PhoneID : NSManagedObjectID {}
@end

@interface _Phone : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PhoneID* objectID;

@property (nonatomic, strong) NSString* number;

//- (BOOL)validateNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Contact *contact;

//- (BOOL)validateContact:(id*)value_ error:(NSError**)error_;

@end

@interface _Phone (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveNumber;
- (void)setPrimitiveNumber:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (Contact*)primitiveContact;
- (void)setPrimitiveContact:(Contact*)value;

@end
