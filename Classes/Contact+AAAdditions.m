//
//  Contact+AAAdditions.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "Contact+AAAdditions.h"

@implementation Contact (AAAdditions)

- (NSString*)fullName
{
    return [self.firstName stringByAppendingFormat:@" %@", self.lastName];
}

@end
