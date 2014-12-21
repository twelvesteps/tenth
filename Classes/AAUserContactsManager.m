//
//  AAUserContactsManager.m
//  Steps
//
//  Created by Tom on 12/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserContactsManager.h"
#import "NSDate+AAAdditions.h"
#import "Contact+AAAdditions.h"
#import "Phone.h"
#import "Email.h"


#define AA_CONTACT_ITEM_NAME            @"Contact"

@interface AAUserContactsManager()

@property (nonatomic, readwrite) BOOL hasUserAddressBookAccess;
@property (nonatomic, assign) ABAddressBookRef addressBook;

@end

@implementation AAUserContactsManager

+ (instancetype)sharedManager
{
    static AAUserContactsManager* sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (void)dealloc
{
    if (_addressBook) {
        CFRelease(_addressBook);
    }
}

- (NSArray*)fetchUserAAContacts
{
    NSSortDescriptor* sortByFirstName = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* sortByLastName = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    NSSortDescriptor* sortByContactID = [NSSortDescriptor sortDescriptorWithKey:@"contactID" ascending:YES];
    NSArray* contactItems = [self fetchItemsForEntityName:AA_CONTACT_ITEM_NAME
                                      withSortDescriptors:@[sortByLastName, sortByFirstName, sortByContactID]
                                            withPredicate:nil];
    DLog(@"Fetched %d contacts", (int)contactItems.count);
    return contactItems;
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
            contact = [contacts lastObject];
            // false match, return nil
            if (![self personRecord:person matchesContact:contact])
                contact = nil;
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
    [self syncContact:contact withPersonRecord:person];
    return contact;
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
    // only one sponsor allowed
    currentSponsor.isSponsor = [NSNumber numberWithBool:NO];
    contact.isSponsor = [NSNumber numberWithBool:YES];
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
        // doesn't exist
        return nil;
    } else if (contacts.count == 1) {
        // found it
        return [contacts lastObject];
    } else {
        // multiple contacts sharing unique identifiers
        DLog(@"<ERROR> Database state violates invarient \"Only one contact with same name and id\"\n %@, %@", err, err.userInfo);
        return nil;
    }
}

// internal search method
- (NSArray*)fetchUserAAContactsWithContactID:(NSNumber*)contactID
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
    NSPredicate* contactIDPredicate = [NSPredicate predicateWithFormat:@"contactID == %@", contactID];
    request.predicate = contactIDPredicate;
    
    NSError* err;
    NSArray* contactsMatchingID = [self.managedObjectContext executeFetchRequest:request error:&err];
    // multiple matches are okay at this point
    return contactsMatchingID;
}




#pragma mark - Creating/Removing Objects
#pragma mark Create

- (Contact*)createContact
{
    return [NSEntityDescription insertNewObjectForEntityForName:AA_CONTACT_ITEM_NAME
                                         inManagedObjectContext:self.managedObjectContext];
}

- (Contact*)createContactWithPersonRecord:(ABRecordRef)person
{
    Contact* contact = [self createContact];
    if (contact) {
        [self syncContact:contact withPersonRecord:person];
        return contact;
    } else {
        ALog(@"<ERROR> Unable to create contact");
        return nil;
    }
}

- (void)removeAAContact:(Contact*)contact
{
    // clean up contact's objects
    // this can probably be done automatically using visual editor
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

void addressBookExternalChangeCallback (ABAddressBookRef addressBook,
                                        CFDictionaryRef userInfo,
                                        void *context)
{
    // external changes are considered truth, reset local address book
    ABAddressBookRevert(addressBook);
}
- (ABAddressBookRef)addressBook
{
    if (!_addressBook)
    {
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRegisterExternalChangeCallback(_addressBook, addressBookExternalChangeCallback, (__bridge void *)(self));
    }
    return _addressBook;
}



- (BOOL)hasUserAddressBookAccess
{
    return [self requestUserAddressBookAccess];
}

- (BOOL)requestUserAddressBookAccess
{
    __block BOOL accessGranted = NO;
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error){
            if (granted && !error) {
                // update address book
                ABAddressBookRevert(self.addressBook);
                accessGranted = YES;
            } else {
                accessGranted = NO;
            }
        });
    } else {
        // return user's previous decision
        accessGranted = (status == kABAuthorizationStatusAuthorized) ? YES : NO;
    }
    
    return accessGranted;
}

- (NSArray*)fetchPersonRecords
{
    NSArray* records = (NSArray*)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(self.addressBook));
    
    return records;
}


#pragma mark Matching Contacts and Address Book Records

- (ABRecordRef)fetchPersonRecordForContact:(Contact *)contact
{
    if (!self.hasUserAddressBookAccess) {
        ALog(@"<ERROR> User has denied phonebook access");
        return NULL;
    }
    
    ABRecordRef person = NULL;
    
    // use contact's id
    if (contact.contactID) {
        DLog(@"<DEBUG> contact id stored in database, using id");
        ABRecordID contactID = (ABRecordID)[contact.contactID intValue];
        person = ABAddressBookGetPersonWithRecordID(self.addressBook, contactID);
        
        // make sure the id is correct
        if (![self personRecord:person matchesContact:contact]) {
            // names don't match, clean person record3
            if (person) {
                CFRelease(person);
            }
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
        }
    }
    
    if (!person) {
        DLog(@"<DEBUG> Not able to locate person record for contact");
        contact.needsABLink = [NSNumber numberWithBool:YES];
    }
    
    // synchronize the contact and person records
    [self syncContact:contact withPersonRecord:person];
    
    return person;
}


- (BOOL)personRecord:(ABRecordRef)person matchesContact:(Contact*)contact
{
    BOOL personNameMatchesContactName = [self personName:person matchesContactName:contact];
    BOOL personPhoneMatchesContactPhone = [self personPhones:person matchContactPhones:contact];
    BOOL personEmailMatchesContactEmail = [self personEmails:person matchContactEmails:contact];
    
    return personNameMatchesContactName && (personPhoneMatchesContactPhone || personEmailMatchesContactEmail);
}

- (BOOL)personName:(ABRecordRef)person matchesContactName:(Contact*)contact
{
#warning This method will fail for company type records
    BOOL result = NO;
    
    if (person) {
        NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        result = [self name:firstName matchesName:contact.abFirstName] && [self name:lastName matchesName:contact.abLastName];
    }
    
    return result;
}

- (BOOL)name:(NSString*)name matchesName:(NSString*)otherName
{
    // nonexistent names count as match (E.G. Dad (null) matches Dad (null)
    if (!name && !otherName) {
        return YES;
    } else {
        return [name isEqualToString:otherName];
    }
}

- (BOOL)personPhones:(ABRecordRef)person matchContactPhones:(Contact*)contact
{
    BOOL result = NO;
    
    if (person) {
        ABMultiValueRef personPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        CFIndex personPhonesCount = ABMultiValueGetCount(personPhones);
        
        
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
        
        if (personPhones) {
            CFRelease(personPhones);
        }
    }
    
    return result;
}

- (BOOL)personEmails:(ABRecordRef)person matchContactEmails:(Contact*)contact
{
    BOOL result = NO;
    
    if (person) {
        ABMultiValueRef personEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        CFIndex personEmailsCount = ABMultiValueGetCount(personEmails);
        
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
        
        if (personEmails) {
            CFRelease(personEmails);
        }
    }
    
    return result;
}


#pragma mark Synchronizing Properties

- (void)syncContact:(Contact*)contact withPersonRecord:(ABRecordRef)person
{
    if (person && contact) {
        [self syncContactName:contact withPersonName:person];
        [self syncContactID:contact withPersonID:person];
        [self syncContactPhones:contact withPersonPhones:person];
        [self syncContactEmails:contact withPersonEmails:person];
        [self syncContactImage:contact withPersonImage:person];
        
        contact.needsABLink = @NO;
    }
}

- (BOOL)syncContactWithAssociatedPersonRecord:(Contact *)contact
{
    // fetchPersonRecordForContact automatically syncs
    ABRecordRef person = [self fetchPersonRecordForContact:contact];
    
    if (!person) {
        return NO;
    } else {
        return YES;
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
        
        [contact clearPhones];
        for (int i = 0; i < ABMultiValueGetCount(phones); i++) {
            NSString* title = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            NSString* number = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phones, i);
            
            [contact addPhoneWithTitle:title number:number];
        }
        
        if (phones) {
            CFRelease(phones);
        }
    }
}

- (void)syncContactEmails:(Contact*)contact withPersonEmails:(ABRecordRef)person
{
    if (person && contact) {
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        [contact clearEmails];
        for (int i = 0; i < ABMultiValueGetCount(emails); i++) {
            NSString* title = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(emails, i);
            NSString* address = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emails, i);
            
            [contact addEmailWithTitle:title address:address];
        }
        
        if (emails) {
            CFRelease(emails);
        }
    }
}

- (void)syncContactImage:(Contact*)contact withPersonImage:(ABRecordRef)person
{
    if (person && contact) {
        NSData* imageData = (__bridge_transfer NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        
        contact.image = imageData;
    }
}

- (BOOL)flush
{
    BOOL result = [super flush];
    
    if (result) {
        // clean address book memory
        if (self.addressBook) {
            CFRelease(self.addressBook);
            self.addressBook = NULL;
        }
    }

    return result;
}

@end
