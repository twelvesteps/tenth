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

@end

@implementation AAUserDataManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
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
    AAUserDataManager* manager = [AAUserDataManager sharedManager];
    NSAssert(manager, @"AAUserDataManager unable to allocate shared instance");
    
    NSArray* amends = [manager fetchUserAmends];
    NSAssert(amends, @"AAUserDataManager unable to fetch amends");
    DLog(@"Amends count: %d", (int)[amends count]);
}

- (void)testAAUserDataManagerCreationMethods
{
    AAUserDataManager* manager = [AAUserDataManager sharedManager];
    
    NSDate* beforeCreation = [NSDate date];
    Amend* amend = [manager createAmend];
    NSDate* afterCreation = [NSDate date];
    NSArray* amends = [manager fetchUserAmends];
    
    NSAssert([amends count] == 1, @"Amend not properly added to context");
    NSAssert([amend.creationDate compare:beforeCreation] == NSOrderedDescending &&
             [amend.creationDate compare:afterCreation] == NSOrderedAscending,
             @"CreationDate not properly set");
    
    DailyInventory* inventory = [manager todaysDailyInventory];
    NSArray* questions = [[inventory.questions allObjects] sortedArrayUsingSelector:@selector(compareQuestionNumber:)];
    DLog(@"First Question Text: %@", [[questions firstObject] questionText]);
}

@end
