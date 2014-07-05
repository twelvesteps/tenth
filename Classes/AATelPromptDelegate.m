//
//  AATelPromptDelegate.m
//  Steps
//
//  Created by tom on 7/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AATelPromptDelegate.h"

@implementation AATelPromptDelegate

+ (instancetype)sharedDelegate
{
    static AATelPromptDelegate* delegate = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        delegate = [[AATelPromptDelegate alloc] init];
        delegate.telPromptDelegate = nil;
    });
    
    return delegate;
}

- (void)fireTelPromptDidCall
{
    if (self.telPromptDelegate) {
        [self.telPromptDelegate telPromptDidCall];
    }
}

- (void)fireTelPromptDidCancel
{
    if (self.telPromptDelegate) {
        [self.telPromptDelegate telPromptDidCancel];
    }
}

@end
