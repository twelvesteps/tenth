//
//  AAUserDataManager.m
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserDataManager.h"
#import "NSDate+AAAdditions.h"
#import "Contact+AAAdditions.h"
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
    return [self fetchItemsForEntityName:AA_AMEND_ITEM_NAME
                     withSortDescriptors:@[sortByDate]
                           withPredicate:nil];
}

- (NSArray*)fetchUserDailyInventories
{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    return [self fetchItemsForEntityName:AA_DAILY_INVENTORY_ITEM_NAME
                     withSortDescriptors:@[sortByDate]
                           withPredicate:nil];
}

- (NSArray*)fetchUserResentments
{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    return [self fetchItemsForEntityName:AA_RESENTMENT_ITEM_NAME
                     withSortDescriptors:@[sortByDate]
                           withPredicate:nil];
}

- (NSArray*)fetchUserAAContacts
{
    NSSortDescriptor* sortByFirstName = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* sortByLastName = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    NSSortDescriptor* sortByContactID = [NSSortDescriptor sortDescriptorWithKey:@"contactID" ascending:YES];
    NSArray* contactItems = [self fetchItemsForEntityName:AA_CONTACT_ITEM_NAME
                                      withSortDescriptors:@[sortByLastName, sortByFirstName, sortByContactID]
                                            withPredicate:nil];

    return contactItems;
}

- (Contact*)fetchSponsor
{
    NSPredicate* sponsorPredicate = [NSPredicate predicateWithFormat:@"isSponsor == %@", [NSNumber numberWithBool:YES]];
    NSArray* sponsors = [self fetchItemsForEntityName:AA_CONTACT_ITEM_NAME
                                  withSortDescriptors:nil
                                        withPredicate:sponsorPredicate];
    
    if (sponsors.count == 0) {
        return nil;
    } else if (sponsors.count == 1) {
        return [sponsors lastObject];
    } else {
        DLog(@"<DEBUG> Only one contact should have sponsor property set");
        return nil;
    }
}

- (void)setContactAsSponsor:(Contact *)contact
{
    Contact* currentSponsor = [self fetchSponsor];
    currentSponsor.isSponsor = [NSNumber numberWithBool:NO];
    contact.isSponsor = [NSNumber numberWithBool:YES];
}

// internal search method
- (NSArray*)fetchUserAAContactsWithContactID:(NSNumber*)contactID
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
    NSPredicate* contactIDPredicate = [NSPredicate predicateWithFormat:@"contactID == %@", contactID];
    request.predicate = contactIDPredicate;
    
    NSError* err;
    NSArray* contactsMatchingID = [self.managedObjectContext executeFetchRequest:request error:&err];
    
    return contactsMatchingID;
}

- (NSArray*)fetchItemsForEntityName:(NSString*)name
                withSortDescriptors:(NSArray*)descriptors
                      withPredicate:(NSPredicate*)predicate
{
    NSError* err;
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:name];
    
    // if no descriptors were passed then sort by the date
    // this may change as the project develops
    if (!descriptors) {
        descriptors = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    }
    
    request.sortDescriptors = descriptors;
    request.predicate = predicate;
    
    
    NSArray* fetchResult = [self.managedObjectContext executeFetchRequest:request error:&err];
    if (!fetchResult) {
        ALog(@"<ERROR> Unable to complete request for %@ items. Error: %@, %@", name, err, err.userInfo);
    }
    
    return fetchResult;
}


#pragma mark - Creating/Removing Objects
#pragma mark Create
- (Amend*)createAmend
{
    return [NSEntityDescription insertNewObjectForEntityForName:AA_AMEND_ITEM_NAME
                                         inManagedObjectContext:self.managedObjectContext];
}

- (Resentment*)createResentment
{
    return [NSEntityDescription insertNewObjectForEntityForName:AA_RESENTMENT_ITEM_NAME
                                         inManagedObjectContext:self.managedObjectContext];
}

- (Contact*)createContact
{
    return [NSEntityDescription insertNewObjectForEntityForName:AA_CONTACT_ITEM_NAME
                                         inManagedObjectContext:self.managedObjectContext];
}

- (Contact*)fetchContactForPersonRecord:(ABRecordRef)person
{
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* lastName  = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSNumber* contactID = [NSNumber numberWithInt:ABRecordGetRecordID(person)];
    Contact* contact = [self fetchContactWithFirstName:firstName lastName:lastName contactID:contactID];
    
    if (!contact) {
        NSArray* contacts = [self fetchContactsWithFirstName:firstName lastName:lastName];
        if (contacts.count == 0) {
            // no matches
            contact = nil;
        } else if (contacts.count == 1) {
            // found it!
            contact = [contacts lastObject];
        } else {
            // multiple matches, check property fields
            for (Contact* cur in contacts) {
                if ([self personRecord:person matchesContact:cur]) {
                    contact = cur;
                    break;
                }
            }
        }
    }
    
    // make sure records remain in sync
    [self syncConactProperties:contact withPersonRecord:person];
    return contact;
}

- (NSArray*)fetchContactsWithFirstName:(NSString*)firstName lastName:(NSString*)lastName
{
    NSPredicate* firstNamePredicate = [NSPredicate predicateWithFormat:@"abFirstName == %@", firstName];
    NSPredicate* lastNamePredicate = [NSPredicate predicateWithFormat:@"abLastName == %@", lastName];
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:AA_CONTACT_ITEM_NAME];
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[firstNamePredicate, lastNamePredicate]];
    
    return [self.managedObjectContext executeFetchRequest:request error:nil];
}

- (Contact*)fetchContactWithFirstName:(NSString *)firstName lastName:(NSString *)lastName contactID:(NSNumber *)contactID
{
    NSPredicate* firstNamePredicate = [NSPredicate predicateWithFormat:@"abFirstName == %@", firstName];
    NSPredicate* lastNamePredicate = [NSPredicate predicateWithFormat:@"abLastName == %@", lastName];
    NSPredicate* contactIDPredicate = [NSPredicate predicateWithFormat:@"contactID == %@", contactID];
    
    NSArray* predicates = @[firstNamePredicate, lastNamePredicate, contactIDPredicate];

    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:AA_CONTACT_ITEM_NAME];
    NSPredicate* contactPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    request.predicate = contactPredicate;

    NSError* err;
    NSArray* contacts = [self.managedObjectContext executeFetchRequest:request error:&err];
    
    if (contacts.count == 0) {
        return nil;
    } else if (contacts.count == 1) {
        return [contacts lastObject];
    } else {
        ALog(@"<ERROR> Database state violates invarient \"Only one contact with same name and id\"\n %@, %@", err, err.userInfo);
        return nil;
    }
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
        return [NSEntityDescription insertNewObjectForEntityForName:AA_DAILY_INVENTORY_ITEM_NAME
                                             inManagedObjectContext:self.managedObjectContext];
    } else if (results.count == 1) {
        return [results lastObject];
    } else {
        ALog(@"<ERROR> Database state violates invariant \"Only one inventory per day\"\n %@, %@", err, err.userInfo);
        return nil;
    }
}

#pragma mark Remove

- (void)removeAmend:(Amend *)amend
{
    [self.managedObjectContext deleteObject:amend];
}

- (void)removeDailyInventory:(DailyInventory *)dailyInventory
{
    [self.managedObjectContext deleteObject:dailyInventory];
}

- (void)removeResentment:(Resentment *)resentment
{
    [self.managedObjectContext deleteObject:resentment];

}

- (void)removeAAContact:(Contact*)contact
{
    for (Email* email in contact.emails) {
        [self.managedObjectContext deleteObject:email];
    }
    
    for (Phone* phone in contact.phones) {
        [self.managedObjectContext deleteObject:phone];
    }
    
    [self.managedObjectContext deleteObject:contact];
}


#pragma mark - Address Book Management
#pragma mark User Address Book Access
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

#pragma mark Matching Contacts and Address Book Records

- (Contact*)createContactWithPersonRecord:(ABRecordRef)person
{
    if (!self.hasUserAddressBookAccess) {
        if (![self requestUserAddressBookAccess]) {
            ALog(@"<ERROR> User has denied phonebook access");
            return nil;
        }
    }
    
    Contact* contact = [self createContact];
    if (contact) {
        [self syncConactProperties:contact withPersonRecord:person];
        return contact;
    } else {
        ALog(@"<ERROR> Unable to create contact");
        return nil;
    }
}

- (ABRecordRef)fetchPersonRecordForContact:(Contact *)contact
{
    if (!self.hasUserAddressBookAccess) {
        if (![self requestUserAddressBookAccess]) {
            ALog(@"<ERROR> User has denied phonebook access");
            return NULL;
        }
    }
    
    ABRecordRef person = NULL;

    // use contact's id
    if (contact.contactID) {
        DLog(@"<DEBUG> contact id stored in database, using id");
        ABRecordID contactID = (ABRecordID)[contact.contactID intValue];
        person = ABAddressBookGetPersonWithRecordID(self.addressBook, contactID);
        
        // make sure the id is correct
        if (![self personRecord:person matchesContact:contact]) {
            person = NULL;
        }
    }
    
    // use contact's name if id is nil or record was not found
    if (!person) {
        DLog(@"<DEBUG> not able to find contact using id, using name");
        CFStringRef name = (__bridge CFStringRef)[contact.firstName stringByAppendingFormat:@" %@", contact.lastName];
        CFArrayRef records = ABAddressBookCopyPeopleWithName(self.addressBook, name);
        
        if (records) {
            CFIndex recordsCount = CFArrayGetCount(records);
            if (recordsCount > 1) {
                // multiple records match name, check that the record matches
                for (CFIndex i = 0; i < recordsCount && !person; i++) {
                    ABRecordRef cur = CFArrayGetValueAtIndex(records, i);
                    
                    // verify that first and last name match
                    if ([self personRecord:cur matchesContact:contact]) {
                        person = cur;
                    }
                }
            } else if (recordsCount == 1) {
                // only one record matches name, assume it's correct
                person = CFArrayGetValueAtIndex(records, 0);
            } else {
                for (CFIndex i = 0; i < recordsCount && !person; i++) {
                    ABRecordRef cur = CFArrayGetValueAtIndex(records, i);
                    // matching name found
                    if ([self personName:cur matchesContactName:contact]) {
                        // multiple names are allowed, check contact details
                        if ([self personPhones:cur matchContactPhones:contact] ||
                            [self personEmails:cur matchContactEmails:contact]) {
                            
                            person = cur;
                        }
                    }
                }
            }
            
            // synchronize the contact and person records
            [self syncConactProperties:contact withPersonRecord:person];
        }
    }
    
    if (!person) {
        DLog(@"<DEBUG> Not able to locate person record for contact");
    }
    
    return person;
}


- (BOOL)personRecord:(ABRecordRef)person matchesContact:(Contact*)contact
{
    BOOL personNameMatchesContactName = [self personName:person matchesContactName:contact];
    BOOL personPhoneMatchesContactPhone = [self personPhones:person matchContactPhones:contact];
    BOOL personEmailMatchesContactEmail = [self personEmails:person matchContactEmails:contact];
    
    return personNameMatchesContactName || personPhoneMatchesContactPhone || personEmailMatchesContactEmail;
}

- (BOOL)personName:(ABRecordRef)person matchesContactName:(Contact*)contact
{
    BOOL result = NO;
    
    if (person) {
        NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        result = [contact.abFirstName isEqualToString:firstName] && [contact.abLastName isEqualToString:lastName];
    }
    
    return result;
}

- (BOOL)personPhones:(ABRecordRef)person matchContactPhones:(Contact*)contact
{
    BOOL result = NO;
    
    if (person) {
        ABMultiValueRef personPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);

        CFIndex personPhonesCount = ABMultiValueGetCount(personPhones);
        if (personPhonesCount == 0 && contact.phones.count) {
            result = YES;
        } else {
            // check all phones for one match
            for (CFIndex i = 0; i < personPhonesCount; i++) {
                NSString* phoneTitle = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(personPhones, i);
                NSString* phoneNumber = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(personPhones, i);
                
                NSSet* phonesWithTitleAndNumber = [contact.phones objectsPassingTest:^BOOL(id obj, BOOL* stop) {
                    Phone* phone = (Phone*)obj;
                    return [phone.title isEqualToString:phoneTitle] && [phone.number isEqualToString:phoneNumber];
                }];
                
                if (phonesWithTitleAndNumber.count > 0) {
                    result = YES;
                    break;
                }
            }
        }
        CFRelease(personPhones);
    }
    
    return result;
}

- (BOOL)personEmails:(ABRecordRef)person matchContactEmails:(Contact*)contact
{
    BOOL result = NO;
    
    if (person) {
        ABMultiValueRef personEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        CFIndex personEmailsCount = ABMultiValueGetCount(personEmails);
        if (personEmailsCount == 0 && contact.emails.count == 0) {
            result = YES;
        } else {
            // check all emails for one match
            for (CFIndex i = 0; i < personEmailsCount; i++) {
                NSString* emailTitle = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(personEmails, i);
                NSString* emailAddress = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(personEmails, i);
                
                NSSet* emailsWithTitleAndAddress = [contact.emails objectsPassingTest:^BOOL(id obj, BOOL* stop) {
                    Email* email = (Email*)obj;
                    return [email.title isEqualToString:emailTitle] && [email.address isEqualToString:emailAddress];
                }];
                
                if (emailsWithTitleAndAddress.count > 0) {
                    result = YES;
                    break;
                }
            }
        }
        CFRelease(personEmails);
    }
    
    return result;
}


#pragma mark Synchronizing Properties

- (void)syncConactProperties:(Contact*)contact withPersonRecord:(ABRecordRef)person
{
    if (!self.hasUserAddressBookAccess) {
        if (![self requestUserAddressBookAccess]) {
            return;
        }
    }
    
    if (person && contact) {
        [self syncContactName:contact withPersonName:person];
        [self syncContactID:contact withPersonID:person];
        [self syncContactPhones:contact withPersonPhones:person];
        [self syncContactEmails:contact withPersonEmails:person];
    }
}

- (void)syncContactName:(Contact*)contact withPersonName:(ABRecordRef)person
{
    if (person && contact) {
        NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        contact.firstName = firstName;
        contact.abFirstName = firstName;
        contact.lastName = lastName;
        contact.abLastName = lastName;
    }
}

- (void)syncContactID:(Contact*)contact withPersonID:(ABRecordRef)person
{
    if (person && contact) {
        NSNumber* contactID = [NSNumber numberWithInt:ABRecordGetRecordID(person)];
        contact.contactID = contactID;
        [self invalidateContactIDsMatchingContact:contact];
    }
}

- (void)invalidateContactIDsMatchingContact:(Contact*)contact
{
    NSArray* contactsMatchingID = [self fetchUserAAContactsWithContactID:contact.contactID];
    for (Contact* curContact in contactsMatchingID) {
        if (![curContact isEqual:contact])
            curContact.contactID = nil;
    }
}

- (void)syncContactPhones:(Contact*)contact withPersonPhones:(ABRecordRef)person
{
    if (person && contact) {
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (int i = 0; i < ABMultiValueGetCount(phones); i++) {
            NSString* title = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            NSString* number = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phones, i);
            
            [contact addPhoneWithTitle:title number:number];
        }
        
        CFRelease(phones);
    }
}

- (void)syncContactEmails:(Contact*)contact withPersonEmails:(ABRecordRef)person
{
    if (person && contact) {
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        for (int i = 0; i < ABMultiValueGetCount(emails); i++) {
            NSString* title = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(emails, i);
            NSString* address = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emails, i);
            
            [contact addEmailWithTitle:title address:address];
        }

        CFRelease(emails);
    }
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
        
        NSString* stepItemsPath = [[[self applicationDocumentsDirectory] path]
                                   stringByAppendingPathComponent:@"StepItems.sqlite"];
        
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


#pragma mark - Persistence

- (BOOL)synchronize
{
    NSError* err;
    BOOL result = [self.managedObjectContext save:&err];
    
    if (!result) {
        ALog(@"<ERROR> Unable to save changes to file\nError: %@, User Info: %@", err, [err userInfo]);
    }
    
    return result;}

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
        if (self.addressBook) {
            CFRelease(self.addressBook);
            self.addressBook = NULL;
        }
    } else {
        ALog(@"<ERROR> Unable to save changes to user data, aborting flush. Check log for error details");
    }
    
    return result;
}

@end
