//
//  NSDate+AAAdditions.h
//  Steps
//
//  Created by Tom on 5/12/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AAAdditions)

+ (NSDate*)dateForStartOfToday;
+ (NSDate*)dateForEndOfToday;
+ (BOOL)dateIsSameDayAsToday:(NSDate*)date;

+ (NSDate*)oneHour;

- (NSInteger)weekday;
- (NSDate*)nearestHalfHour;

@end
