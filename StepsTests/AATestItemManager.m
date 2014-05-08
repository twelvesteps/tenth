//
//  AATestItemManager.m
//  Steps
//
//  Created by Tom on 5/7/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AAItemManager.h"
#import "AATenthStepItem.h"

@interface AATestItemManager : XCTestCase

@end

@implementation AATestItemManager

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

- (void)testInterface
{
    AAItemManager* manager = [AAItemManager sharedItemManager];
    assert(manager);
    assert([manager respondsToSelector:@selector(updateStepItemsForStep:withItems:)]);
    assert([manager respondsToSelector:@selector(getItemsForStep:)]);
    assert([manager respondsToSelector:@selector(synchronize)]);
}

- (void)testGetStepItems
{
    AAItemManager* manager = [AAItemManager sharedItemManager];
    assert(manager);
    
    for (int i = 1; i <= 12; i++) {
        assert([manager getItemsForStep:i]);
    }
}

- (void)testModifyStepItems
{
    AAItemManager* manager = [AAItemManager sharedItemManager];
    assert(manager);
    
    NSArray* tenthStepItems = nil;
    NSMutableArray* mutableTenthStepItems = [[NSMutableArray alloc] init];
    AATenthStepItem* tenthStepItem = [[AATenthStepItem alloc] init];
    
    [mutableTenthStepItems addObject:tenthStepItem];
    [manager updateStepItemsForStep:[tenthStepItem stepNumber] withItems:[mutableTenthStepItems copy]];
    
    tenthStepItems = [manager getItemsForStep:10];
    assert(tenthStepItems);
    assert([tenthStepItems count] == 1);
    assert([[tenthStepItems lastObject] isEqual:tenthStepItem]);
    
    for (int i = 0; i < 9; i++) {
        [mutableTenthStepItems addObject:[[AATenthStepItem alloc] init]];
    }
    
    [manager updateStepItemsForStep:10 withItems:[mutableTenthStepItems copy]];
    tenthStepItems = [manager getItemsForStep:10];
    assert(tenthStepItems);
    assert([tenthStepItems count] == 10);
    DLog(@"stepItem: %@", [tenthStepItems lastObject]);
    
}

- (void)testSynchronize
{
    AAItemManager* manager = [AAItemManager sharedItemManager];
    assert(manager);
    
    NSMutableArray* mutableTenthStepItems = [[NSMutableArray alloc] init];
    AATenthStepItem* tenthStepItem = [[AATenthStepItem alloc] init];
    
    [mutableTenthStepItems addObject:tenthStepItem];
    [manager updateStepItemsForStep:10 withItems:[mutableTenthStepItems copy]];
    [manager flush]; // calls synchronize method and forces manager to reload data from file
    NSArray* tenthStepItems = [manager getItemsForStep:10];
    assert([tenthStepItems count] == 1);
}

@end
