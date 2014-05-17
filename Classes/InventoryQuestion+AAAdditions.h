//
//  InventoryQuestion+AAAdditions.h
//  Steps
//
//  Created by Tom on 5/14/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "InventoryQuestion.h"

#define AA_DAILY_INVENTORY_QUESTION_COUNT                   9
#define AA_DAILY_INVENTORY_QUESTION_DISCUSS_QUESTION_INDEX  5

typedef NS_ENUM(NSUInteger, AADailyInventoryQuestionType) {
    AADailyInventoryQuestionYesNoType,
    AADailyInventoryQuestionDescriptionType,
};

@interface InventoryQuestion (AAAdditions)

+ (InventoryQuestion*)questionForNumber:(NSNumber*)number;

- (NSComparisonResult)compareQuestionNumber:(InventoryQuestion*)otherQuestion;

- (NSString*)questionText;

@end
