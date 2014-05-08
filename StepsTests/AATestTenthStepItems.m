//
//  AATestTenthStepItems.m
//  Steps
//
//  Created by Tom on 5/4/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AATenthStepItem.h"

@interface AATestTenthStepItems : XCTestCase

@end

@implementation AATestTenthStepItems

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

-(void)testProperties
{
    AATenthStepItem* item = [[AATenthStepItem alloc] init];
    
    assert([item.itemTitle isEqualToString:@"Title"]);
    assert([item.itemDescription isEqualToString:@""]);
    assert(item.stepNumber == 10);
    
    NSString* title = @"New Title";
    item.itemTitle = title;
    assert([item.itemTitle isEqualToString:title]);
    
    NSString* description = @"Description";
    item.itemDescription = description;
    assert([item.itemDescription isEqualToString:description]);
    
    assert(item.stepNumber == 10);
}

-(void)testEncoding
{
    AATenthStepItem* item = [[AATenthStepItem alloc] init];
    item.itemTitle = @"Encoded";
    item.itemDescription = @"Encoded";
    
    NSData* encodedItem = [NSKeyedArchiver archivedDataWithRootObject:item];
    AATenthStepItem* decodedItem = [NSKeyedUnarchiver unarchiveObjectWithData:encodedItem];
    
    assert([decodedItem.itemTitle isEqualToString:item.itemTitle]);
    assert([decodedItem.itemDescription isEqualToString:item.itemDescription]);
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedItem forKey:@"item"];
    
    [defaults synchronize];
    
    NSData* retrievedItem = [[NSUserDefaults standardUserDefaults] objectForKey:@"item"];
    decodedItem = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedItem];
    assert([decodedItem.itemTitle isEqualToString:item.itemTitle]);
    assert([decodedItem.itemDescription isEqualToString:item.itemDescription]);
    assert(decodedItem.stepNumber == 10);
}

@end
