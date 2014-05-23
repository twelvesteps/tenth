//
//  AAUserDataManager.m
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserDataManager.h"
#import "NSDate+AAAdditions.h"
#import "Phone.h"
#import "Email.h"
#import <CoreData/CoreData.h>

#define AA_AMEND_ITEM_NAME              @"Amend"
#define AA_DAILY_INVENTORY_ITEM_NAME    @"DailyInventory"
#define AA_RESENTMENT_ITEM_NAME         @"Resentment"
#define AA_CONTACT_ITEM_NAME            @"Contact"

@interface AAUserDataManager ()

@property (nonatomic) BOOL hasUserAddressBookAccess;
@property (nonatomic, assign) ABAddressBookRef addressBook;
@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@end

@implementation AAUserDataManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager
{
    static AAUserDataManager* sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[AAUserDataManager alloc] init];
        sharedManager.hasUserAddressBookAccess = NO;
    });
    
    return sharedManager;
}

- (void)dealloc
{
    if (_addressBook) {
        CFRelease(_addressBook);
    }
}


#pragma mark - Fetching Objects

- (NSArray*)fetchUserAmends
{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    return [self fetchItemsForEntityName:AA_AMEND_ITEM_NAME withSortDescriptors:@[sortByDate]];
}

- (NSArray*)fetchUserDailyInventories
{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    return [self fetchItemsForEntityName:AA_DAILY_INVENTORY_ITEM_NAME withSortDescriptors:@[sortByDate]];
}

- (NSArray*)fetchUserResentments
{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    return [self fetchItemsForEntityName:AA_RESENTMENT_ITEM_NAME withSortDescriptors:@[sortByDate]];
}

- (NSArray*)fetchUserAAContacts
{
    NSSortDescriptor* sortByFirstName = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* sortByLastName = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    NSArray* contactItems = [self fetchItemsForEntityName:AA_CONTACT_ITEM_NAME withSortDescriptors:@[sortByLastName, sortByFirstName]];

    return contactItems;
}

- (NSArray*)fetchItemsForEntityName:(NSString*)name withSortDescriptors:(NSArray*)descriptors
{
    NSError* err;
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    
    // if no descriptors were passed then sort by the date
    // this may change as the project develops
    if (!descriptors) {
        descriptors = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    }
    
    [request setEntity:description];
    [request setSortDescriptors:descriptors];
    
    NSArray* fetchResult = [self.managedObjectContext executeFetchRequest:request error:&err];
    if (!fetchResult) {
        ALog(@"<ERROR> Unable to complete request for %@ items. Error: %@, %@", name, err, err.userInfo);
    }
    
    return fetchResult;
}


#pragma mark - Creating/Deleting Objects

- (Amend*)createAmend
{
    return [NSEntityDescription insertNewObjectForEntityForName:AA_AMEND_ITEM_NAME inManagedObjectContext:self.managedObjectContext];
}

- (Contact*)createContact
{
    return [NSEntityDescription insertNewObjectForEntityForName:AA_CONTACT_ITEM_NAME inManagedObjectContext:self.managedObjectContext];
}

- (DailyInventory*)todaysDailyInventory
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:AA_DAILY_INVENTORY_ITEM_NAME];
    NSPredicate* startDatePredicate = [NSPredicate predicateWithFormat:@"date >= %@", [NSDate dateForStartOfToday]];
    NSPredicate* endDatePredicate = [NSPredicate predicateWithFormat:@"date <= %@", [NSDate dateForEndOfToday]];
    NSPredicate* todayPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[startDatePredicate, endDatePredicate]];
    request.predicate = todayPredicate;
    
    NSError* err;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&err];
    
    if (results.count == 0) {
        return [NSEntityDescription insertNewObjectForEntityForName:AA_DAILY_INVENTORY_ITEM_NAME inManagedObjectContext:self.managedObjectContext];
    } else if (results.count == 1) {
        return [results lastObject];
    } else {
        ALog(@"<ERROR> Database state violates invariant \"Only one inventory per day\"\n %@, %@", err, err.userInfo);
        return nil;
    }
}

- (Resentment*)createResentment
{
    return [NSEntityDescription insertNewObjectForEntityForName:AA_RESENTMENT_ITEM_NAME inManagedObjectContext:self.managedObjectContext];
}

- (void)deleteAmend:(Amend *)amend
{
    [self.managedObjectContext deleteObject:amend];
}

- (void)deleteDailyInventory:(DailyInventory *)dailyInventory
{
    [self.managedObjectContext deleteObject:dailyInventory];
}

- (void)deleteResentment:(Resentment *)resentment
{
    [self.managedObjectContext deleteObject:resentment];

}


#pragma mark - Core Data Management

- (NSManagedObjectContext *)managedObjectContext {
	
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [NSManagedObjectContext new];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
	
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (!_persistentStoreCoordinator) {
        
        NSString* stepItemsPath = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:@"StepItems.sqlite"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:stepItemsPath]) {
            [[NSFileManager defaultManager] createFileAtPath:stepItemsPath contents:nil attributes:nil];
        }
        
        _persistentStoreCoordinator =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSError *error;
        NSURL *stepItemsURL = [NSURL fileURLWithPath:stepItemsPath];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:stepItemsURL
                                                             options:nil
                                                               error:&error]) {
            ALog(@"<ERROR> Unable to open Step Items database. Error %@", error);
        }
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Address Book Management

- (ABAddressBookRef)addressBook
{
    if (!_addressBook) _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    return _addressBook;
}

- (BOOL)requestUserAddressBookAccess
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusNotDetermined) {
        __block __weak AAUserDataManager *weakself = self;
        ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error){
            if (granted && !error) {
                ABAddressBookRevert(weakself.addressBook);
                weakself.hasUserAddressBookAccess = YES;
            } else {
                weakself.hasUserAddressBookAccess = NO;
            }
        });
    } else {
        self.hasUserAddressBookAccess = (status == kABAuthorizationStatusAuthorized) ? YES : NO;
    }
    
    
    return self.hasUserAddressBookAccess;
}

- (BOOL)addContactForPersonRecord:(ABRecordRef)contact
{
    if (!self.hasUserAddressBookAccess) {
        if (![self requestUserAddressBookAccess]) {
            ALog(@"<ERROR> User has denied phonebook access");
            return NO;
        }
    }
    
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contact, kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contact, kABPersonLastNameProperty);
    NSNumber* contactID = [NSNumber numberWithInt:ABRecordGetRecordID(contact)];
    
    Contact* managedContact = [self createContact];
    
        if (managedContact) {
            managedContact.firstName = firstName;
            managedContact.lastName = lastName;
            managedContact.id = contactID;
            
            return YES;
        } else {
            ALog(@"<ERROR> Unable to create contact in application's local database");
            return NO;
        }
}

- (ABRecordRef)personRecordFromAddressBookForContact:(Contact *)contact
{
    if (!self.hasUserAddressBookAccess) {
        if (![self requestUserAddressBookAccess]) {
            ALog(@"<ERROR> User has denied phonebook access");
            return NULL;
        }
    }
    
    ABRecordRef record = NULL;

    // use contact's id
    if (contact.id) {
        DLog(@"<DEBUG> contact id stored in database, using id");
        ABRecordID contactID = (ABRecordID)[contact.id intValue];
        record = ABAddressBookGetPersonWithRecordID(self.addressBook, contactID);
        
        // make sure the id is correct
        NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString* lastName  = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
        if (!([contact.firstName isEqualToString:firstName] && [contact.lastName isEqualToString:lastName])) {
            record = NULL;
        }
    }
    
    // use contact's name if id is nil or record was not found
    if (!record) {
        DLog(@"<DEBUG> not able to find contact using id, using name");
        CFStringRef name = (__bridge CFStringRef)[contact.firstName stringByAppendingFormat:@" %@", contact.lastName];
        CFArrayRef records = ABAddressBookCopyPeopleWithName(self.addressBook, name);
        
        if (records) {
            NSUInteger count = CFArrayGetCount(records);
            for (NSUInteger i = 0; i < count && !record; i++) {
                ABRecordRef cur = CFArrayGetValueAtIndex(records, i);
                
                // verify that first and last name match
                NSString* curFirstName = (__bridge_transfer NSString*)ABRecordCopyValue(cur, kABPersonFirstNameProperty);
                NSString* curLastName = (__bridge_transfer NSString*)ABRecordCopyValue(cur, kABPersonLastNameProperty);
                if ([contact.firstName isEqualToString:curFirstName] && [contact.lastName isEqualToString:curLastName]) {
                    record = cur;
                    contact.id = [NSNumber numberWithInt:ABRecordGetRecordID(record)];
                }
            }
        }
    }
    
    return record;
}

- (BOOL)addContactToUserAddressBook:(Contact *)contact
{
    if (!self.hasUserAddressBookAccess) {
        if (![self requestUserAddressBookAccess]) {
            ALog(@"<ERROR> User has denied phonebook access");
            return NO;
        }
    }
    
    ABRecordRef record = [self personRecordFromAddressBookForContact:contact];
    CFErrorRef error;

    if (!record) {
        record = ABPersonCreate();
        ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFStringRef)contact.firstName, NULL);
        ABRecordSetValue(record, kABPersonLastNameProperty, (__bridge CFStringRef)contact.lastName, NULL);
        
        [self addContactProperties:contact toPersonRecord:record];
    }

    BOOL result = (BOOL)ABAddressBookAddRecord(self.addressBook, record, &error);

    if (!result) {
        ALog(@"<ERROR> Unable to save contact to phone, Error: %@", (__bridge_transfer NSString*)CFErrorCopyDescription(error));
    }
    
    return result;
}

- (void)addContactProperties:(Contact*)contact toPersonRecord:(ABRecordRef)person
{
    if (person) {
        // add phone numbers
        ABMultiValueRef phones = [self getMultiValueRefForPersonRecord:person forProperty:kABPersonPhoneProperty];
        NSArray* contactPhones = [contact.phones allObjects];
        for (Phone* phone in contactPhones) {
            ABMultiValueAddValueAndLabel(phones, (__bridge CFStringRef)phone.number, (__bridge CFStringRef)phone.title, NULL  );
        }
        
        ABMultiValueRef emails = [self getMultiValueRefForPersonRecord:person forProperty:kABPersonEmailProperty];
        NSArray* contactEmails = [contact.emails allObjects];
        for (Email* email in contactEmails) {
            ABMultiValueAddValueAndLabel(emails, (__bridge CFStringRef)email.address, (__bridge CFStringRef)email.title, NULL);
        }
        
        ABRecordSetValue(person, kABPersonPhoneProperty, phones, NULL);
        ABRecordSetValue(person, kABPersonEmailProperty, emails, NULL);
    }
}

- (ABMultiValueRef)getMultiValueRefForPersonRecord:(ABRecordRef)person forProperty:(ABPropertyType)property
{
    ABMultiValueRef values = ABRecordCopyValue(person, property);
    if (!values)
        values = ABMultiValueCreateMutable(property);
    return values;
}


#pragma mark - Persistence

- (BOOL)synchronize
{
    BOOL cdResult = [self saveManagedObjectContextChanges];
    BOOL abResult = [self saveAddressBookChanges];
    
    return cdResult && abResult;
}

- (BOOL)flush
{
    BOOL result = [self synchronize];
    
    // if save was successful continue
    if (result) {
        // clean core data memory
        self.managedObjectContext = nil;
        self.managedObjectModel = nil;
        self.persistentStoreCoordinator = nil;
        
        // clean address book memory
        CFRelease(self.addressBook);
        self.addressBook = NULL;
    } else {
        ALog(@"<ERROR> Unable to save changes to user data, aborting flush. Check log for error details");
    }
    
    return result;
}

- (BOOL)saveManagedObjectContextChanges
{
    NSError* err;
    BOOL result = [self.managedObjectContext save:&err];
    
    if (!result) {
        ALog(@"<ERROR> Unable to save changes to file\nError: %@, User Info: %@", err, [err userInfo]);
    }
    
    return result;
}

- (BOOL)saveAddressBookChanges
{
    BOOL result = YES; // pessimism :(
    
    if (ABAddressBookHasUnsavedChanges(self.addressBook)) {
        CFErrorRef error;
        result = (BOOL)(ABAddressBookSave(self.addressBook, &error));
        
        if (!result) {
            ALog(@"<ERROR> Unable to save changes to user address book, %@",
                 (__bridge_transfer NSString*)CFErrorCopyDescription(error));
        }
    }
    
    return result;
}

@end
