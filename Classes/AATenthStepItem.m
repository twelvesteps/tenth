//
//  AATenthStepItem.m
//  Steps
//
//  Created by Tom on 5/4/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AATenthStepItem.h"

#define AA_TENTH_STEP_ITEM_TITLE        @"title"
#define AA_TENTH_STEP_ITEM_DESCRIPTION  @"description"
@implementation AATenthStepItem

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

#pragma mark Encoding Methods
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:AA_TENTH_STEP_ITEM_TITLE];
    [aCoder encodeObject:self.description forKey:AA_TENTH_STEP_ITEM_DESCRIPTION];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _title = [aDecoder decodeObjectForKey:AA_TENTH_STEP_ITEM_TITLE];
        _description = [aDecoder decodeObjectForKey:AA_TENTH_STEP_ITEM_DESCRIPTION];
    }
    
    return self;
}


@end
