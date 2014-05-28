//
//  Contact+AAAdditions.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//


#import "Contact+AAAdditions.h"
#import "Contact.h"
#import "Amend.h"
#import "Email.h"
#import "Phone.h"
#import "Resentment.h"


@implementation Contact (AAAdditions)

- (NSString*)fullName
{
    return [self.firstName stringByAppendingFormat:@" %@", self.lastName];
}

- (void)addPhoneWithTitle:(NSString *)title number:(NSString *)number
{
    Phone* phone = [NSEntityDescription insertNewObjectForEntityForName:@"Phone" inManagedObjectContext:self.managedObjectContext];
    phone.title = title;
    phone.number = number;
    
    [self addPhonesObject:phone];
}

- (void)addEmailWithTitle:(NSString *)title address:(NSString *)address
{
    Email* email = [NSEntityDescription insertNewObjectForEntityForName:@"Email" inManagedObjectContext:self.managedObjectContext];
    email.title = title;
    email.address = address;
    
    [self addEmailsObject:email];
}

@end
