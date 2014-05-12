//
//  DailyInventoryQuestion.h
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AA_DAILY_INVENTORY_QUESTIONS_COUNT  9

typedef NSUInteger AADailyInventoryQuestionsAnswerCode;
static const AADailyInventoryQuestionsAnswerCode AADailyInventoryEmptyAnswerCode = 0;

@interface AADailyInventoryQuestion : NSObject

@property (nonatomic) NSUInteger number;
@property (nonatomic) BOOL answer;
@property (nonatomic, strong) NSString* questionText;

+ (AADailyInventoryQuestionsAnswerCode)answerCodeForQuestions:(NSArray*)questions;
+ (NSArray*)questionsForAnswerCode:(AADailyInventoryQuestionsAnswerCode)answerCode;
+ (NSArray*)allQuestions;
@end
