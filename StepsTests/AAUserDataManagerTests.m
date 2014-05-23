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

@interface AAUserDataManagerTests : XCTestCase

@property (strong, nonatomic) AAUserDataManager* manager;

@end

@implementation AAUserDataManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if (!_manager)
        _manager = [AAUserDataManager sharedManager];
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
    NSDate* beforeCreation = [NSDate date];
    Amend* amend = [self.manager createAmend];
    NSDate* afterCreation = [NSDate date];
    NSArray* amends = [self.manager fetchUserAmends];
    
    NSAssert([amends count] == 1, @"Amend not properly added to context");
    NSAssert([amend.creationDate compare:beforeCreation] == NSOrderedDescending &&
             [amend.creationDate compare:afterCreation] == NSOrderedAscending,
             @"CreationDate not properly set");
    
    DailyInventory* inventory = [self.manager todaysDailyInventory];
    NSArray* questions = [[inventory.questions allObjects] sortedArrayUsingSelector:@selector(compareQuestionNumber:)];
    DLog(@"First Question Text: %@", [[questions firstObject] questionText]);
}

- (void)testAddPersonToUserAddressBook
{
    Contact* contact = [self.manager createContact];
    contact.firstName = @"Johnny";
    contact.lastName  = @"Appleseed";
    
    ABRecordRef person = [self.manager personRecordFromAddressBookForContact:contact];
    NSAssert(!person, @"Person should not exist");
    
    BOOL result = [self.manager addContactToUserAddressBook:contact];
    result = [self.manager synchronize];
    person = [self.manager personRecordFromAddressBookForContact:contact];
    NSAssert(person, @"Person record not successfully added");
}

@end
