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
    
    assert([item.title isEqualToString:@"Title"]);
    assert([item.description isEqualToString:@""]);
    
    NSString* title = @"New Title";
    [item setTitle:title];
    assert([item.title isEqualToString:title]);
    
    NSString* description = @"Description";
    [item setDescription:description];
    assert([item.description isEqualToString:description]);
}

-(void)testEncoding
{
    AATenthStepItem* item = [[AATenthStepItem alloc] init];
    item.title = @"Encoded";
    item.description = @"Encoded";
    
    NSData* encodedItem = [NSKeyedArchiver archivedDataWithRootObject:item];
    AATenthStepItem* decodedItem = [NSKeyedUnarchiver unarchiveObjectWithData:encodedItem];
    
    assert([decodedItem.title isEqualToString:item.title]);
    assert([decodedItem.description isEqualToString:item.description]);
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedItem forKey:@"item"];
    
    [defaults synchronize];
    
    NSData* retrievedItem = [[NSUserDefaults standardUserDefaults] objectForKey:@"item"];
    decodedItem = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedItem];
    assert([decodedItem.title isEqualToString:item.title]);
    assert([decodedItem.description isEqualToString:item.description]);
    
}

@end
