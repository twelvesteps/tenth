//
//  AATelPromptDelegate.h
//  Steps
//
//  Created by tom on 7/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AATelPromptDelegate <NSObject>

- (void)telPromptDidCall;
- (void)telPromptDidCancel;

@end

@interface AATelPromptDelegate : NSObject

@property (weak, nonatomic) id<AATelPromptDelegate> telPromptDelegate;

+ (instancetype)sharedDelegate;

- (void)fireTelPromptDidCall;
- (void)fireTelPromptDidCancel;

@end
