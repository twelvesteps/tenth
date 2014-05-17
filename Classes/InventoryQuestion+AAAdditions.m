//
//  InventoryQuestion+AAAdditions.m
//  Steps
//
//  Created by Tom on 5/14/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "InventoryQuestion+AAAdditions.h"
#import "AAUserDataManager.h"

#define AA_INVENTORY_QUESTION_NAME          @"InventoryQuestion"
#define AA_INVENTORY_QUESTION_YES_NO_COUNT  8

@implementation InventoryQuestion (AAAdditions)

+ (InventoryQuestion*)questionForNumber:(NSNumber *)number
{
    NSManagedObjectContext* context = [AAUserDataManager sharedManager].managedObjectContext;
    
    InventoryQuestion* question = [NSEntityDescription insertNewObjectForEntityForName:AA_INVENTORY_QUESTION_NAME inManagedObjectContext:context];
    question.number = number;
    
    NSUInteger numberValue = [number integerValue];
    if (numberValue < AA_INVENTORY_QUESTION_YES_NO_COUNT) {
        question.type = [NSNumber numberWithInteger:AADailyInventoryQuestionYesNoType];
    } else {
        question.type = [NSNumber numberWithInteger:AADailyInventoryQuestionDescriptionType];
    }
    
    return question;
}

- (NSComparisonResult)compareQuestionNumber:(InventoryQuestion *)otherQuestion
{
    NSUInteger intValue = [self.number integerValue];
    NSUInteger otherValue = [otherQuestion.number integerValue];
    
    if (intValue > otherValue) {
        return NSOrderedDescending;
    } else if (intValue < otherValue) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

- (NSString*)questionText
{
    return [InventoryQuestion questionTextForNumber:self.number];
}

+ (NSString*)questionTextForNumber:(NSNumber*)number
{
    return [[InventoryQuestion questionTexts] objectAtIndex:[number integerValue]];
}

+ (NSArray*)questionTexts
{
    static NSArray* questionTexts = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        questionTexts = [NSArray arrayWithObjects:
                         @"Was I resentful?",
                         @"Was I selfish?",
                         @"Was I dishonest",
                         @"Was I afraid?",
                         @"Do I owe an apology?",
                         @"Have I kept something to myself which should be discussed with another person at once?",
                         @"Was I kind and loving toward all?",
                         @"Was I thinking of myself most of the time?",
                         @"What could I have done better?",
                         nil];
    });
    
    return questionTexts;
}

@end
