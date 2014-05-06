//
//  AAStepItem.m
//  Steps
//
//  Created by Tom on 5/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAStepItem.h"

#define AA_STEP_ITEM_TITLE          @"title"
#define AA_STEP_ITEM_DESCRIPTION    @"description"
#define AA_STEP_ITEM_NUMBER         @"number"

@implementation AAStepItem

#pragma mark Properties
-(NSString*)itemTitle
{
    if (!_itemTitle) _itemTitle = @"Title";
    return _itemTitle;
}

-(NSString*)itemDescription
{
    if (!_itemDescription) _itemDescription = @"";
    return _itemDescription;
}

-(NSNumber*)number
{
    return [[NSNumber alloc] initWithInt:0];
}

#pragma mark Encoding Methods
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemTitle forKey:AA_STEP_ITEM_TITLE];
    [aCoder encodeObject:self.itemDescription forKey:AA_STEP_ITEM_DESCRIPTION];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.itemTitle =       [aDecoder decodeObjectForKey:AA_STEP_ITEM_TITLE];
        self.itemDescription = [aDecoder decodeObjectForKey:AA_STEP_ITEM_DESCRIPTION];
    }
    
    return self;
}


@end
