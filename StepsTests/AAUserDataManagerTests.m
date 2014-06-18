//
//  AAUserDataManagerTests.m
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AAUserDataManager.h"
#import "Email.h"
#import "Phone.h"
#import "InventoryQuestion+AAAdditions.h"
#import "NSDate+AAAdditions.h"
#import <AddressBook/AddressBook.h>

@interface AAUserDataManagerTests : XCTestCase

@property (strong, nonatomic) AAUserDataManager* manager;
@property (nonatomic) ABAddressBookRef addressBook;

@end

@implementation AAUserDataManagerTests


#pragma mark - ABAddressBook Helper Functions and Defines

#define PROPERTY_TITLE_KEY  @"Title"
#define PROPERTY_VALUE_KEY  @"Value"

#define BILL_FIRST_NAME     @"Bill"
#define BILL_LAST_NAME      @"Wilson"
#define LOIS_FIRST_NAME     @"Lois"
#define LOIS_LAST_NAME      @"Wilson"
#define BOB_FIRST_NAME      @"Doctor"
#define BOB_LAST_NAME       @"Bob"

- (ABRecordRef)personRecordWithFirstName:(NSString*)firstName
                                lastName:(NSString*)lastName
                                  phones:(NSArray*)phones
                                  emails:(NSArray*)emails
{
    ABRecordRef person = ABPersonCreate();
    
    ABMutableMultiValueRef abPhones = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMutableMultiValueRef abEmails = ABMultiValueCreateMutable(kABPersonEmailProperty);
    
    for (NSDictionary* phone in phones) {
        CFStringRef value = (__bridge CFStringRef)[phone objectForKey:PROPERTY_VALUE_KEY];
        CFStringRef title = (__bridge CFStringRef)[phone objectForKey:PROPERTY_TITLE_KEY];
        ABMultiValueAddValueAndLabel(abPhones, value, title, NULL);
    }
    
    for (NSDictionary* email in emails) {
        CFStringRef title = (__bridge CFStringRef)[email objectForKey:PROPERTY_TITLE_KEY];
        CFStringRef value = (__bridge CFStringRef)[email objectForKey:PROPERTY_VALUE_KEY];
        ABMultiValueAddValueAndLabel(abEmails, value, title, NULL);
    }
    
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)firstName, NULL);
    ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFStringRef)lastName, NULL);
    ABRecordSetValue(person, kABPersonPhoneProperty, abPhones, NULL);
    ABRecordSetValue(person, kABPersonEmailProperty, abEmails, NULL);
    
    return person;
}

- (NSArray*)createPhonesWithFinalDigit:(NSUInteger)digit count:(NSUInteger)count
{
    NSMutableArray* mutablePhones = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < count; i++) {
        NSString* title = [NSString stringWithFormat:@"%d", (int)i];
        NSString* value = [NSString stringWithFormat:@"%d%d", (int)i, (int)digit];
        [mutablePhones addObject:@{PROPERTY_TITLE_KEY: title, PROPERTY_VALUE_KEY: value}];
    }
    
    return [mutablePhones copy];
}

- (NSArray*)createEmailsWithDomain:(NSString*)domain count:(NSUInteger)count
{
    NSMutableArray* mutableEmails = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < count; i++) {
        NSString* title = [NSString stringWithFormat:@"%d", (int)i];
        NSString* value = [NSString stringWithFormat:@"%d@%@.com", (int)i, domain];
        [mutableEmails addObject:@{PROPERTY_TITLE_KEY: title, PROPERTY_VALUE_KEY: value}];
    }
    
    return [mutableEmails copy];
}

- (BOOL)insertPersonRecord:(ABRecordRef)person
{
    bool result = ABAddressBookAddRecord(self.addressBook, person, NULL);
    if (!result) return NO;
    
    result = ABAddressBookSave(self.addressBook, NULL);
    if (!result) return NO;
    
    ABAddressBookRevert(self.addressBook);
    return YES;
}

- (ABRecordRef)fetchPersonRecord:(ABRecordRef)person
{
    ABRecordRef fetchedPerson = NULL;
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    CFIndex emailsCount = ABMultiValueGetCount(emails);
    CFStringRef name = (__bridge CFStringRef)[firstName stringByAppendingFormat:@" %@", lastName];
    CFArrayRef people = ABAddressBookCopyPeopleWithName(self.addressBook, name);
    
    CFIndex count = CFArrayGetCount(people);
    if (count == 0) fetchedPerson = NULL;
    else if (count == 1) fetchedPerson = CFArrayGetValueAtIndex(people, 0);
    else {
        for (CFIndex i = 0; i < count; i++) {
            ABRecordRef cur = CFArrayGetValueAtIndex(people, i);
            ABMultiValueRef abEmails = ABRecordCopyValue(cur, kABPersonEmailProperty);
            
            CFIndex abEmailsCount = ABMultiValueGetCount(abEmails);
            // no emails, temporarily assume this is the correct person
            if (abEmailsCount == 0 && emailsCount == 0) {
                fetchedPerson = cur;
            } else {
                NSString* emailValue = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(abEmails, 0);
                
                for (CFIndex i = 0; i < emailsCount; i++) {
                    if ([emailValue isEqualToString:(__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emails, i)]) {
                        fetchedPerson = cur;
                        break;
                    }
                }
                
                if (fetchedPerson) break;
            }
        }
    }
    
    CFRelease(emails);
    return fetchedPerson;
}

- (ABRecordRef)insertAndFetchPersonRecordFromAddressBook:(ABRecordRef)person
{
    [self insertPersonRecord:person];
    return [self fetchPersonRecord:person];
}

- (ABRecordRef)createAndInsertPersonRecordWithFirstName:(NSString*)firstName
                                               lastName:(NSString*)lastName
                                             phoneCount:(NSUInteger)phoneCount
                                             emailCount:(NSUInteger)emailCount
{
    NSArray* phones = [self createPhonesWithFinalDigit:1 count:phoneCount];
    NSArray* emails = [self createEmailsWithDomain:firstName count:emailCount];
    ABRecordRef person = [self personRecordWithFirstName:firstName lastName:lastName phones:phones emails:emails];
    
    BOOL result = [self insertPersonRecord:person];
    if (!result) return NULL;
    
    ABRecordRef fetchedPerson = [self insertAndFetchPersonRecordFromAddressBook:person];
    CFRelease(person);
    
    return fetchedPerson;
}

- (void)removePersonRecordFromAddressBook:(ABRecordRef)person
{
    ABAddressBookRemoveRecord(self.addressBook, person, NULL);
    ABAddressBookSave(self.addressBook, NULL);
    ABAddressBookRevert(self.addressBook);
}

- (void)assertContact:(Contact*)contact matchesPersonRecord:(ABRecordRef)person
{
    NSString* personFirstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* personLastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSNumber* personID = [NSNumber numberWithInt:ABRecordGetRecordID(person)];
    
    XCTAssertNotNil(contact);
    XCTAssert([contact.abFirstName isEqualToString:personFirstName]);
    XCTAssert([contact.abLastName isEqualToString:personLastName]);
    XCTAssertEqualObjects(personID, contact.contactID);
    [self assertContactPhones:contact matchesPersonRecordPhones:person];
    [self assertContactEmails:contact matchesPersonRecordEmails:person];
}

- (void)assertContactPhones:(Contact*)contact matchesPersonRecordPhones:(ABRecordRef)person
{
    ABMultiValueRef abPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phonesCount = ABMultiValueGetCount(abPhones);
    for (CFIndex i = 0; i < phonesCount; i++) {
        NSString* abPhoneTitle = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(abPhones, i);
        NSString* abPhoneValue = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(abPhones, i);
        
        NSSet* matchingPhone = [contact.phones objectsPassingTest:^BOOL(id obj, BOOL* stop) {
            Phone* phone = (Phone*)obj;
            return ([phone.title isEqualToString:abPhoneTitle] && [phone.number isEqualToString:abPhoneValue]);
        }];
        
        XCTAssert(matchingPhone.count == 1);
    }
}

- (void)assertContactEmails:(Contact*)contact matchesPersonRecordEmails:(ABRecordRef)person
{
    ABMultiValueRef abEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
    CFIndex emailsCount = ABMultiValueGetCount(abEmails);
    for (CFIndex i = 0; i < emailsCount; i++) {
        NSString* abEmailTitle = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(abEmails, i);
        NSString* abEmailValue = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(abEmails, i);
        
        NSSet* matchingEmail = [contact.emails objectsPassingTest:^BOOL(id obj, BOOL* stop) {
            Email* email = (Email*)obj;
            return ([email.title isEqualToString:abEmailTitle] && [email.address isEqualToString:abEmailValue]);
        }];
        
        XCTAssert(matchingEmail.count == 1);
    }
}

- (void)assertPhones:(NSArray*)phones containPhone:(Phone*)phone
{
    BOOL hasMatch = NO;
    for (NSDictionary* phoneDict in phones) {
        NSString* title = [phoneDict objectForKey:PROPERTY_TITLE_KEY];
        NSString* value = [phoneDict objectForKey:PROPERTY_VALUE_KEY];
        
        if ([phone.title isEqualToString:title] && [phone.number isEqualToString:value]) {
            hasMatch = YES;
        }
    }
    
    XCTAssert(hasMatch, @"Couldn't find a matching phone");
}

- (void)assertEmails:(NSArray*)emails containEmail:(Email*)email
{
    BOOL hasMatch = NO;
    for (NSDictionary* emailDict in emails) {
        NSString* title = [emailDict objectForKey:PROPERTY_TITLE_KEY];
        NSString* value = [emailDict objectForKey:PROPERTY_VALUE_KEY];
        
        if ([email.title isEqualToString:title] && [email.address isEqualToString:value]) {
            hasMatch = YES;
        }
    }
    
    XCTAssert(hasMatch, @"Couldn't find a matching email");
}


#pragma mark - XCTest Lifecycle

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if (!_manager)
        _manager = [AAUserDataManager sharedManager];
    
    if (!_addressBook) {
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                ABAddressBookRevert(_addressBook);
            }
        });
    }
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


#pragma mark - Test initialization

- (void)testSingletonInstance
{
    AAUserDataManager* manager1 = [AAUserDataManager sharedManager];
    AAUserDataManager* manager2 = [AAUserDataManager sharedManager];
    
    XCTAssert(manager1 && manager2, @"AAUserDataManager unable to allocate shared instance");
    XCTAssert(manager1 == manager2, @"AAUserDataManager sharedManager returned different instances");
}


#pragma mark - Test CoreData

- (void)testCreateOneAmend
{
    NSDate* beforeCreation = [NSDate date];
    Amend* amend = [self.manager createAmend];
    NSDate* afterCreation = [NSDate date];
    
    XCTAssert([self.manager fetchUserAmends].count == 1, @"Amend not properly added to context");
    XCTAssert([amend.creationDate compare:beforeCreation] == NSOrderedDescending &&
             [amend.creationDate compare:afterCreation] == NSOrderedAscending,
             @"CreationDate not properly set");
    
    // clean amends from database
    [self.manager removeAmend:amend];
    XCTAssert([self.manager fetchUserAmends].count == 0, @"Amend not removed");
}

- (void)testCreateMultipleAmmends
{
    // create multiple ammends
    for (int i = 0; i < 10; i++) {
        Amend* amend = [self.manager createAmend];
        amend.amends = [NSString stringWithFormat:@"Amend%d", i];
    }
    
    XCTAssert([self.manager fetchUserAmends].count == 10, @"Amends not properly added");
    
    // clean up amends
    NSArray* amends = [self.manager fetchUserAmends];
    for (Amend* amend in amends) {
        [self.manager removeAmend:amend];
    }
    
    XCTAssert([self.manager fetchUserAmends].count == 0, @"Amends not properly removed");
}

- (void)testUniqueInventoryForDay
{
    // create inventory
    DailyInventory* inventory = [self.manager todaysDailyInventory];
    DailyInventory* inventory2 = [self.manager todaysDailyInventory];
    XCTAssert([NSDate dateIsSameDayAsToday:inventory.date], @"Today's inventory is incorrect date");
    XCTAssert([inventory isEqual:inventory2], @"todaysDailyInventory should only create one item per day");
    XCTAssert([inventory.questions count] == AA_DAILY_INVENTORY_QUESTION_COUNT, @"Improper number of questions created");
}

- (void)testSimpleContactCreation
{
    Contact* contact = [self.manager createContact];
    XCTAssert(contact, @"Contact created");
    XCTAssertNil(contact.firstName, @"First Name property was improperly set");
    XCTAssertNil(contact.lastName, @"Last name property was improperly set");
    
    NSArray* allContacts = [self.manager fetchUserAAContacts];
    XCTAssert([allContacts containsObject:contact], @"Contact not found by manager");
    
    // remove contact
    [self.manager removeAAContact:contact];
}


#pragma mark - Test CoreData and ABAddressBook interaction

- (void)testSimpleContactCreatingAndFetchingWithPersonRecord
{
    ABRecordRef abBill = [self createAndInsertPersonRecordWithFirstName:BILL_FIRST_NAME lastName:BILL_LAST_NAME phoneCount:1 emailCount:1];
    
    Contact* bill = [self.manager createContactWithPersonRecord:abBill];
    [self assertContact:bill matchesPersonRecord:abBill];
    
    [self.manager removeAAContact:bill];
    bill = [self.manager fetchContactForPersonRecord:abBill];
    XCTAssertNil(bill);
    
    [self removePersonRecordFromAddressBook:abBill];
    CFRelease(abBill);
}

- (void)testCreatingAndFetchingMultipleContacts
{
    ABRecordRef abBill = [self createAndInsertPersonRecordWithFirstName:BILL_FIRST_NAME lastName:BILL_LAST_NAME phoneCount:1 emailCount:1];
    ABRecordRef abLois = [self createAndInsertPersonRecordWithFirstName:LOIS_FIRST_NAME lastName:LOIS_LAST_NAME phoneCount:1 emailCount:1];
    
    
    Contact* bill = [self.manager createContactWithPersonRecord:abBill];
    Contact* lois = [self.manager createContactWithPersonRecord:abLois];
    
    [self assertContact:bill matchesPersonRecord:abBill];
    [self assertContact:lois matchesPersonRecord:abLois];
    
    [self.manager removeAAContact:bill];
    [self.manager removeAAContact:lois];
    
    XCTAssertNil([self.manager fetchContactForPersonRecord:abBill]);
    XCTAssertNil([self.manager fetchContactForPersonRecord:abLois]);
    
    [self removePersonRecordFromAddressBook:abBill];
    [self removePersonRecordFromAddressBook:abLois];
    CFRelease(abBill);
    CFRelease(abLois);
}

- (void)testAddingMultipleContactsWithSameName
{
    ABRecordRef abBill1 = [self createAndInsertPersonRecordWithFirstName:BILL_FIRST_NAME lastName:BILL_LAST_NAME phoneCount:1 emailCount:1];
    
    NSArray* bill2Phones = [self createPhonesWithFinalDigit:2 count:1];
    NSArray* bill2Emails = [self createEmailsWithDomain:@"bill2" count:1];
    ABRecordRef abBill2 = [self personRecordWithFirstName:BILL_FIRST_NAME lastName:BILL_LAST_NAME phones:bill2Phones emails:bill2Emails];
    abBill2 = [self insertAndFetchPersonRecordFromAddressBook:abBill2];
    
    Contact* bill1 = [self.manager createContactWithPersonRecord:abBill1];
    Contact* bill2 = [self.manager createContactWithPersonRecord:abBill2];
    
    XCTAssertNotEqual(bill1, bill2);
    XCTAssertNotEqual([self.manager fetchContactForPersonRecord:abBill1], [self.manager fetchContactForPersonRecord:abBill2]);
    XCTAssertNotNil(bill1.contactID);
    XCTAssertNotNil(bill2.contactID);
    XCTAssertNotEqual(bill1.contactID, bill2.contactID);
    
    [self.manager removeAAContact:bill1];
    [self.manager removeAAContact:bill2];
    
    [self removePersonRecordFromAddressBook:abBill1];
    [self removePersonRecordFromAddressBook:abBill2];
    
    CFRelease(abBill1);
    CFRelease(abBill2);
}

- (void)testCorrectlyLocatesAndSyncsWithRecordAfterPropertyChanges
{
    ABRecordRef abBob = [self createAndInsertPersonRecordWithFirstName:BOB_FIRST_NAME lastName:BOB_LAST_NAME phoneCount:1 emailCount:1];
    Contact* bob = [self.manager createContactWithPersonRecord:abBob];
    
    bob.emails = nil;
    bob.phones = nil;
    
    bob = [self.manager fetchContactForPersonRecord:abBob];
    [self assertContact:bob matchesPersonRecord:abBob];

    [self removePersonRecordFromAddressBook:abBob];
    
    [self.manager removeAAContact:bob];
    CFRelease(abBob);
}


- (void)testCorrectlyLocatesAndSyncsWithRecordAfterContactIDChange
{
    ABRecordRef abBob = [self createAndInsertPersonRecordWithFirstName:BOB_FIRST_NAME lastName:BOB_LAST_NAME phoneCount:1 emailCount:1];
    Contact* bob = [self.manager createContactWithPersonRecord:abBob];

    bob.contactID = nil;
    bob = [self.manager fetchContactForPersonRecord:abBob];
    
    [self assertContact:bob matchesPersonRecord:abBob];
    
    bob.contactID = [NSNumber numberWithInt:(unsigned)-1];
    bob = [self.manager fetchContactForPersonRecord:abBob];
    
    [self assertContact:bob matchesPersonRecord:abBob];
    
    [self.manager removeAAContact:bob];
    [self removePersonRecordFromAddressBook:abBob];
    CFRelease(abBob);
}

- (void)testReturnsNullWhenRecordCantBeLocated
{
    ABRecordRef abBob = [self createAndInsertPersonRecordWithFirstName:BOB_FIRST_NAME lastName:BOB_LAST_NAME phoneCount:1 emailCount:1];
    Contact* bob = [self.manager createContactWithPersonRecord:abBob];
    
    bob.contactID = nil;
    bob.abFirstName = BILL_FIRST_NAME;
    bob.abLastName = BOB_LAST_NAME;
    Contact* nilBob = [self.manager fetchContactForPersonRecord:abBob];
    
    XCTAssertNil(nilBob);
    
    [self.manager removeAAContact:bob];
    [self removePersonRecordFromAddressBook:abBob];
    CFRelease(abBob);
}

- (void)testSimilarRecordsDoNotMatch
{
    ABRecordRef abBill = [self createAndInsertPersonRecordWithFirstName:BILL_FIRST_NAME lastName:BILL_LAST_NAME phoneCount:1 emailCount:0];
    ABRecordRef abLois = [self createAndInsertPersonRecordWithFirstName:LOIS_FIRST_NAME lastName:LOIS_LAST_NAME phoneCount:1 emailCount:0];
    
    Contact* lois = [self.manager createContactWithPersonRecord:abLois];
    
    // remove record from address book and clear data manager
    [self removePersonRecordFromAddressBook:abLois];
    
    ABRecordRef abLoisCopy = [self.manager fetchPersonRecordForContact:lois];
    
    XCTAssert(!abLoisCopy, @"Lois was removed from address book");
    
    [self.manager removeAAContact:lois];
    [self removePersonRecordFromAddressBook:abBill];

    CFRelease(abBill);
    CFRelease(abLois);

}

@end
