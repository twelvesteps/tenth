// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Email.h instead.

#import <CoreData/CoreData.h>

extern const struct EmailAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *title;
} EmailAttributes;

extern const struct EmailRelationships {
	__unsafe_unretained NSString *contact;
} EmailRelationships;

@class Contact;

@interface EmailID : NSManagedObjectID {}
@end

@interface _Email : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) EmailID* objectID;

@property (nonatomic, strong) NSString* address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Contact *contact;

//- (BOOL)validateContact:(id*)value_ error:(NSError**)error_;

@end

@interface _Email (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (Contact*)primitiveContact;
- (void)setPrimitiveContact:(Contact*)value;

@end
