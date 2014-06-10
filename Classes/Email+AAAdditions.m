//
//  Email+AAAdditions.m
//  Steps
//
//  Created by tom on 6/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "Email+AAAdditions.h"
#import <AddressBook/AddressBook.h>

@implementation Email (AAAdditions)

- (NSString*)formattedTitle
{
    // no label constants exist for email, must check manually
    if ([self.title hasPrefix:@"_$!<"] && [self.title hasSuffix:@">!$_"]) {
        return [self.title substringWithRange:NSMakeRange(4, self.title.length - 8)];
    } else {
        return self.title;
    }
}

@end
