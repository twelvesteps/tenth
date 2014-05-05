//
//  AAStepItem.h
//  Steps
//
//  Created by Tom on 5/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAStepItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSNumber* number; // virtual, must be overriden by child

@end
