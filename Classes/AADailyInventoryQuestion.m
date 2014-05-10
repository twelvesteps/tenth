//
//  DailyInventoryQuestion.m
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AADailyInventoryQuestion.h"

@interface AADailyInventoryQuestion ()



@end

@implementation AADailyInventoryQuestion

- (instancetype)init
{
    DLog(@"Instantiate DailyInventoryQuestions with questionNumber class method");
    return nil;
}

// only for use by class
- (instancetype)initWithQuestion:(NSString*)question
{
    self = [super init];
    
    if (self) {
        self.question = question;
    }
    
    return self;
}

+ (instancetype)questionNumber:(NSUInteger)number
{
    if (number >= [AADailyInventoryQuestion questions].count)
        number = [AADailyInventoryQuestion questions].count - 1;
    
    NSString* question = [[AADailyInventoryQuestion questions] objectAtIndex:number];
    
    return [[AADailyInventoryQuestion alloc] initWithQuestion:question];
}


+ (NSArray*)questions
{
    static NSArray* questions = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        questions = @[@"Was I resentful?",
                      @"Was I selfish?",
                      @"Was I dishonest",
                      @"Was I afraid?",
                      @"Do I owe an apology?",
                      @"Have I kept something to myself which should be discussed with another person at once?",
                      @"Was I kind and loving toward all?",
                      @"What could I have done better?",
                      @"Was I thinking of myself most of the time?"];
    });
    
    return questions;
}

@end
