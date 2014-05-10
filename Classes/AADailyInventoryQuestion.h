//
//  DailyInventoryQuestion.h
//  Steps
//
//  Created by Tom on 5/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AADailyInventoryQuestion : NSObject

@property (nonatomic, strong) NSString* question;

+ (instancetype)questionNumber:(NSUInteger)number;

@end
