//
//  AATenthStepItem.h
//  Steps
//
//  Created by Tom on 5/4/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "AAStepItem.h"

@interface AATenthStepItem : AAStepItem

@property (strong, nonatomic) NSDate* dateCompleted;
@property (strong, nonatomic) NSString* characterDefect;
@property (strong, nonatomic) NSString* ammends;
@property (strong, nonatomic) EKReminder* reminder;

@end
