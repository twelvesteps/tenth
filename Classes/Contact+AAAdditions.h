//
//  Contact+AAAdditions.h
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "Contact.h"

@interface Contact (AAAdditions)

- (NSString*)fullName;

- (void)addPhoneWithTitle:(NSString*)title number:(NSString*)number;
- (void)addEmailWithTitle:(NSString*)title address:(NSString*)address;

@end
