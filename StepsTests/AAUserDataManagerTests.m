//
//  AAUserDataManagerTests.m
//  Steps
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AAUserDataManager.h"
#import "InventoryQuestion+AAAdditions.h"
#import "NSDate+AAAdditions.h"
#import <AddressBook/AddressBook.h>

@interface AAUserDataManagerTests : XCTestCase

@property (strong, nonatomic) AAUserDataManager* manager;
@property (nonatomic) ABAddressBookRef addressBook;

@end

@implementation AAUserDataManagerTests

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
#pragma mark ABAddressBook Helper Functions and Defines

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

- (NSArray*)createPhonesWithCount:(NSUInteger)count
{
    NSMutableArray* mutablePhones = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < count; i++) {
        NSString* title = [NSString stringWithFormat:@"%d", (int)i];
        NSString* value = [NSString stringWithFormat:@"%d", (int)i];
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

- (ABRecordRef)createAndInsertPersonRecordWithFirstName:(NSString*)firstName
                                               lastName:(NSString*)lastName
                                             phoneCount:(NSUInteger)phoneCount
                                             emailCount:(NSUInteger)emailCount
{
    NSArray* phones = [self createPhonesWithCount:phoneCount];
    NSArray* emails = [self createEmailsWithDomain:[firstName stringByAppendingString:lastName] count:emailCount];
    ABRecordRef person = [self personRecordWithFirstName:firstName lastName:lastName phones:phones emails:emails];
    
    BOOL result = [self insertPersonRecord:person];
    if (!result) return NULL;
    
    CFRelease(person);
    person = NULL;
    
    CFStringRef name = (__bridge CFStringRef)[firstName stringByAppendingFormat:@" %@", lastName];
    CFArrayRef people = ABAddressBookCopyPeopleWithName(self.addressBook, name);
    
    CFIndex count = CFArrayGetCount(people);
    if (count == 0) person = NULL;
    else if (count == 1) person = CFArrayGetValueAtIndex(people, 0);
    else {
        for (CFIndex i = 0; i < count; i++) {
            ABRecordRef cur = CFArrayGetValueAtIndex(people, i);
            ABMultiValueRef abEmails = ABRecordCopyValue(cur, kABPersonEmailProperty);
            NSString* emailValue = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(abEmails, 0);
            
            for (NSDictionary* email in emails) {
                if ([[email objectForKey:PROPERTY_VALUE_KEY] isEqualToString:emailValue]) {
                    person = cur;
                    break;
                }
            }
            
            if (person) break;
        }
    }
    
    return person;
}

- (void)testSimpleContactCreatingAndFetchingWithPersonRecord
{
    ABRecordRef abBill = [self createAndInsertPersonRecordWithFirstName:BILL_FIRST_NAME lastName:BILL_LAST_NAME phoneCount:1 emailCount:1];
    NSNumber* contactID = [NSNumber numberWithInt:ABRecordGetRecordID(abBill)];
    
    Contact* bill = [self.manager createContactWithPersonRecord:abBill];
    XCTAssertNotNil(bill, @"Contact wasn't created");
    XCTAssert([bill.firstName isEqualToString:BILL_FIRST_NAME]);
    XCTAssert([bill.abFirstName isEqualToString:BILL_FIRST_NAME]);
    XCTAssert([bill.lastName isEqualToString:BILL_LAST_NAME]);
    XCTAssert([bill.abLastName isEqualToString:BILL_LAST_NAME]);
    XCTAssert([bill.contactID isEqual:contactID]);
}

- (void)testCreateContactsWithIncompleteNames
{

}

- (void)testAddingMultipleContactsWithSameName
{
    
}

- (void)testCorrectlyLocatesRecordAfterPropertyChanges
{
    
}


- (void)testCorrectlyLocatesRecordAfterNameChange
{
    
}

- (void)testCorrectlyLocatesRecordAfterContactIDChange
{
    
}

- (void)testCorrectlyUpdatesAddressBook
{
    
}

@end
