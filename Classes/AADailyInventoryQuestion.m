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
        self.questionText = question;
    }
    
    return self;
}

+ (instancetype)questionWithNumber:(NSUInteger)number
{
    if (number >= [AADailyInventoryQuestion questionStrings].count)
        number = [AADailyInventoryQuestion questionStrings].count - 1;
    
    NSString* questionText = [[AADailyInventoryQuestion questionStrings] objectAtIndex:number];
    
    
    AADailyInventoryQuestion* question = [[AADailyInventoryQuestion alloc] initWithQuestion:questionText];
    question.number = number;
    
    return question;
}

+ (AADailyInventoryQuestionsAnswerCode)answerCodeForQuestions:(NSArray *)questions
{
    AADailyInventoryQuestionsAnswerCode answerCode = 0;
    for (AADailyInventoryQuestion* question in questions) {
        if (question.answer == YES) {
            answerCode += 1 << question.number;
        }
    }
    
    return answerCode;
}

+ (NSArray*)allQuestions
{
    return [AADailyInventoryQuestion questionsForAnswerCode:AADailyInventoryEmptyAnswerCode];
}


+ (NSArray*)questionsForAnswerCode:(AADailyInventoryQuestionsAnswerCode)answerCode
{
    NSMutableArray* questions = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < AA_DAILY_INVENTORY_QUESTIONS_COUNT; i++) {
        NSUInteger answerMask = 1 << i;
        AADailyInventoryQuestion* question = [AADailyInventoryQuestion questionWithNumber:i];
        question.answer = ((answerCode & answerMask) != 0) ? YES : NO;
        
        [questions addObject:question];
    }
    
    return [questions copy];
}


+ (NSArray*)questionStrings
{
    static NSArray* questionStrings = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        questionStrings = @[@"Was I resentful?",
                      @"Was I selfish?",
                      @"Was I dishonest",
                      @"Was I afraid?",
                      @"Do I owe an apology?",
                      @"Have I kept something to myself which should be discussed with another person at once?",
                      @"Was I kind and loving toward all?",
                      @"What could I have done better?",
                      @"Was I thinking of myself most of the time?"];
    });
    
    return questionStrings;
}

@end
