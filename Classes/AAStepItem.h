//
//  AAStepItem.h
//  Steps
//
//  Created by Tom on 5/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAStepItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString* person;
@property (nonatomic, strong) NSString* itemDescription;
@property (nonatomic, strong) NSDate* dateCreated;
@property (nonatomic) NSUInteger stepNumber; // virtual, must be overriden by child

@end
