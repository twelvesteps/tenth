//
//  Phone+AAAdditions.m
//  Steps
//
//  Created by tom on 6/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "Phone+AAAdditions.h"
#import <AddressBook/AddressBook.h>

@implementation Phone (AAAdditions)

- (NSString*)formattedTitle
{
    NSString* formattedTitle = [[Phone phoneTitleLabels] objectForKey:self.title];
    if (!formattedTitle) { // label not listed in ABPersonRecord constants
        if ([self.title hasPrefix:@"_$!<"] && [self.title hasSuffix:@">!$_"]) {
            return [self.title substringWithRange:NSMakeRange(4, self.title.length - 8)];
        } else {
            return self.title;
        }
    } else {
        return formattedTitle;
    }
}

+ (NSDictionary*)phoneTitleLabels
{
    static NSDictionary* phoneTitleLabels = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        phoneTitleLabels =
        @{(__bridge_transfer NSString*)kABPersonPhoneMobileLabel: NSLocalizedString(@"Mobile", @"Mobile phone"),
          (__bridge_transfer NSString*)kABPersonPhoneIPhoneLabel: NSLocalizedString(@"iPhone", @"iPhone"),
          (__bridge_transfer NSString*)kABPersonPhoneMainLabel: NSLocalizedString(@"Main", @"Main phone"),
          (__bridge_transfer NSString*)kABPersonPhoneHomeFAXLabel: NSLocalizedString(@"Home Fax", @"Home fax machine"),
          (__bridge_transfer NSString*)kABPersonPhoneWorkFAXLabel: NSLocalizedString(@"Work Fax", @"Work fax machine"),
          (__bridge_transfer NSString*)kABPersonPhoneOtherFAXLabel: NSLocalizedString(@"Other Fax", @"Other fax machine"),
          (__bridge_transfer NSString*)kABPersonPhonePagerLabel: NSLocalizedString(@"Pager", @"Pager number")};
    });
    
    return phoneTitleLabels;
}

@end
