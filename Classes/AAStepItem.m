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
-(NSString*)title
{
    if (!_title) _title = @"Title";
    return _title;
}

-(NSString*)description
{
    if (!_description) _description = @"";
    return _description;
}

-(NSNumber*)number
{
    return [[NSNumber alloc] initWithInt:0];
}

#pragma mark Encoding Methods
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:AA_STEP_ITEM_TITLE];
    [aCoder encodeObject:self.description forKey:AA_STEP_ITEM_DESCRIPTION];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _title =        [aDecoder decodeObjectForKey:AA_STEP_ITEM_TITLE];
        _description =  [aDecoder decodeObjectForKey:AA_STEP_ITEM_DESCRIPTION];
    }
    
    return self;
}


@end
