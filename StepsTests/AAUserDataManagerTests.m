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

- (void)testSingletonInstance
{
    AAUserDataManager* manager1 = [AAUserDataManager sharedManager];
    AAUserDataManager* manager2 = [AAUserDataManager sharedManager];
    
    NSAssert(manager1 && manager2, @"AAUserDataManager unable to allocate shared instance");
    NSAssert(manager1 == manager2, @"AAUserDataManager sharedManager returned different instances");
}

- (void)testFetchUserAmends
{
    NSArray* amends = [self.manager fetchUserAmends];
    NSAssert(amends, @"AAUserDataManager unable to fetch amends");
    DLog(@"Amends count: %d", (int)[amends count]);
}

- (void)testAAUserDataManagerCreationMethods
{
    [self amendCreationTests];
    [self inventoryCreationTests];
    [self contactCreationTests];
}

- (void)amendCreationTests
{
    NSDate* beforeCreation = [NSDate date];
    Amend* amend = [self.manager createAmend];
    NSDate* afterCreation = [NSDate date];
    NSArray* amends = [self.manager fetchUserAmends];
    
    NSAssert([amends count] == 1, @"Amend not properly added to context");
    NSAssert([amend.creationDate compare:beforeCreation] == NSOrderedDescending &&
             [amend.creationDate compare:afterCreation] == NSOrderedAscending,
             @"CreationDate not properly set");
}

- (void)inventoryCreationTests
{
    DailyInventory* inventory = [self.manager todaysDailyInventory];
    DailyInventory* inventory2 = [self.manager todaysDailyInventory];
    XCTAssert([NSDate dateIsSameDayAsToday:inventory.date], @"Today's inventory is incorrect date");
    XCTAssert([inventory isEqual:inventory2], @"todaysDailyInventory should only create one item per day");
    XCTAssert([inventory.questions count] == AA_DAILY_INVENTORY_QUESTION_COUNT, @"Improper number of questions created");
}

- (void)contactCreationTests
{
    Contact* contact = [self.manager contactWithFirstName:nil lastName:nil contactID:nil];
    XCTAssert(contact, @"Contact with nil properties not created");
    XCTAssertNil(contact.firstName, @"First Name property was improperly set");
    XCTAssertNil(contact.lastName, @"Last name property was improperly set");
    
    contact = [self.manager contactWithFirstName:@"Johnny" lastName:nil contactID:nil];
    XCTAssert(contact, @"Contact with first name not created");
    XCTAssert([contact.firstName isEqualToString:@"Johnny"], @"First name not properly set");
    
    contact = [self.manager contactWithFirstName:@"Johnny" lastName:@"Appleseed" contactID:nil];
    XCTAssert([contact.firstName isEqualToString:@"Johnny"], @"First name not properly set");
    XCTAssert([contact.lastName isEqualToString:@"Appleseed"], @"Last name not properly set");
}


- (void)testSimpleAddingAndRemovingFromAddressBook
{
    // create new contact and add to address book
    Contact* contact = [self.manager contactWithFirstName:@"Johnny" lastName:@"Appleseed" contactID:nil];
    
    BOOL result = [self.manager addContactToUserAddressBook:contact];
    XCTAssert(result, @"Error adding contact");
    
    ABRecordRef person = [self.manager personRecordFromAddressBookForContact:contact];
    XCTAssert(person, @"Contact could not be found");
    
    // retrieve contact from database, should return the newly created contact
    Contact* contactCopy = [self.manager contactForPersonRecord:person];
    XCTAssert([contact isEqual:contactCopy], @"Record not properly stored");
    
    result = [self.manager addContactToUserAddressBook:contactCopy];
    XCTAssert(result, @"Failed to locate contact copy");
    
    ABRecordRef person1 = [self.manager personRecordFromAddressBookForContact:contact];
    ABRecordRef person2 = [self.manager personRecordFromAddressBookForContact:contactCopy];
    XCTAssert(CFEqual(person1, person2), @"Only one copy of the person record should exist");
    
    BOOL firstRemoveResult = [self.manager removeContactFromUserAddressBook:contact];
    BOOL secondRemoveResult = [self.manager removeContactFromUserAddressBook:contactCopy];
    XCTAssert(firstRemoveResult, @"Could not remove contact");
    XCTAssertFalse(secondRemoveResult, @"Contact should only be removed once");
    
    // clean up local database
    [self.manager removeAAContact:contact];
}

#define XCTAssertEqualContactID(contact, person) XCTAssertEqualObjects(contact.contactID, [NSNumber numberWithInt:ABRecordGetRecordID(person)], @"Contact ID did not update")


- (void)testCorrectlyLocatesRecordAfterContactIDChange
{
    Contact* contact = [self.manager contactWithFirstName:@"Johnny" lastName:@"Appleseed" contactID:nil];
    [self.manager addContactToUserAddressBook:contact];
    ABRecordRef person = [self.manager personRecordFromAddressBookForContact:contact];
    
    // contact IDs should be unique, search database if ID is in use
    XCTAssertEqualContactID(contact, person);
    
    // change contact ID
    contact.contactID = [NSNumber numberWithInt:[contact.contactID intValue] + 1];
    person = [self.manager personRecordFromAddressBookForContact:contact];
    XCTAssertEqualContactID(contact, person);
}

- (void)testCorrectlyUpdatesAddressBook
{
    
}

@end
