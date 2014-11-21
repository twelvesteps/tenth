//
//  Contact+AAAdditions.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//


#import "Contact+AAAdditions.h"
#import "Amend.h"
#import "Email.h"
#import "Phone.h"
#import "Resentment.h"


@implementation Contact (AAAdditions)

- (NSString*)fullName
{
    if (self.firstName && self.lastName) {
        return [self.firstName stringByAppendingFormat:@" %@", self.lastName];
    } else if (self.firstName) {
        return self.firstName;
    } else if (self.lastName) {
        return self.lastName;
    } else {
        return @"No Name";
    }
}

- (UIImage*)thumbnailImage
{
    if (self.image) {
        return [UIImage imageWithData:self.image];
    } else {
        return nil;
    }
}

- (void)addPhoneWithTitle:(NSString *)title number:(NSString *)number
{
    // check if phone already exists
    NSSet* phonesWithTitle = [self.phones objectsPassingTest:^BOOL(id obj, BOOL* stop) {
        Phone* phone = (Phone*)obj;
        return [phone.title isEqualToString:title];
    }];
    
    if (phonesWithTitle.count == 0) {
        // create new phone and add to object
        Phone* phone = [self newPhoneWithTitle:title number:number];
        [self addPhonesObject:phone];
    } else if (phonesWithTitle.count == 1) {
        // phone exists, update number
        Phone* phone = [[phonesWithTitle allObjects] lastObject];
        phone.number = number;
    } else {
        // error: each phone title should be unique per contact
        ALog(@"<ERROR> Multiple phone numbers exist with same title \"%@\", adding new phone number to list", title);

        // add phone to end of list, allow user to correct error later
        Phone* phone = [self newPhoneWithTitle:title number:number];
        [self addPhonesObject:phone];
    }
}

- (void)addEmailWithTitle:(NSString *)title address:(NSString *)address
{
    NSSet* emailsWithTitle = [self.emails objectsPassingTest:^BOOL(id obj, BOOL* stop) {
        Email* email = (Email*)obj;
        return [email.title isEqualToString:title];
    }];
    
    if (emailsWithTitle.count == 0) {
        // create new email and add to object
        Email* email = [self newEmailWithTitle:title address:address];
        [self addEmailsObject:email];
    } else if (emailsWithTitle.count == 1) {
        // email exists, update address
        Email* email = [[emailsWithTitle allObjects] lastObject];
        email.address = address;
    } else {
        // error: each email title should be unique per contact
        ALog(@"<ERROR> Multiple email addresses exist with the same title \"%@\", adding new email address to contact", title);
        
        // add email to end of list, allow user to correct error later
        Email* email = [self newEmailWithTitle:title address:address];
        [self addEmailsObject:email];
    }
}

- (Phone*)newPhoneWithTitle:(NSString*)title number:(NSString*)number
{
    Phone* phone = [NSEntityDescription insertNewObjectForEntityForName:@"Phone" inManagedObjectContext:self.managedObjectContext];
    phone.title = title;
    phone.number = number;
    
    return phone;
}

- (Email*)newEmailWithTitle:(NSString*)title address:(NSString*)address
{
    Email* email = [NSEntityDescription insertNewObjectForEntityForName:@"Email" inManagedObjectContext:self.managedObjectContext];
    email.title = title;
    email.address = address;
    
    return email;
}

- (void)clearPhones
{
    [self removePhones:self.phones];
}

- (void)clearEmails
{
    [self removeEmails:self.emails];
}

@end
