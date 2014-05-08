//
//  AATenthStepItem.m
//  Steps
//
//  Created by Tom on 5/4/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AATenthStepItem.h"

#define AA_TENTH_STEP_CHARACTER_DEFECT  @"characterDefect"
#define AA_TENTH_STEP_AMMENDS           @"ammends"
#define AA_TENTH_STEP_REMINDER          @"reminder"
#define AA_TENTH_STEP_DATE_COMPLETED    @"dateCompleted"


@implementation AATenthStepItem

-(NSUInteger)stepNumber
{
    return 10;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.characterDefect forKey:AA_TENTH_STEP_CHARACTER_DEFECT];
    [aCoder encodeObject:self.ammends forKey:AA_TENTH_STEP_AMMENDS];
    [aCoder encodeObject:self.reminder forKey:AA_TENTH_STEP_REMINDER];
    [aCoder encodeObject:self.dateCompleted forKey:AA_TENTH_STEP_DATE_COMPLETED];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.characterDefect = [aDecoder decodeObjectForKey:AA_TENTH_STEP_CHARACTER_DEFECT];
        self.ammends = [aDecoder decodeObjectForKey:AA_TENTH_STEP_AMMENDS];
        self.reminder = [aDecoder decodeObjectForKey:AA_TENTH_STEP_REMINDER];
        self.dateCompleted = [aDecoder decodeObjectForKey:AA_TENTH_STEP_DATE_COMPLETED];
    }
    
    return self;
}
@end
