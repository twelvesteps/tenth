//
//  NBPhoneNumberUtil+AAAdditions.m
//  Steps
//
//  Created by tom on 6/2/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "NBPhoneNumberUtil+AAAdditions.h"

@implementation NBPhoneNumberUtil (AAAdditions)

- (NSString*)formattedPhoneNumberFromNumber:(NSString*)number
{
    NBPhoneNumberUtil* phoneUtil = [NBPhoneNumberUtil sharedInstance];
    NSString* normalizedPhoneNumber = [self numberByRemovingLeadingZerosFromNumber:[phoneUtil normalizePhoneNumber:number]];
    NSString* regionCode = [phoneUtil getRegionCodeForCountryCode:[phoneUtil extractCountryCode:normalizedPhoneNumber nationalNumber:nil]];
    
    NSError* err = nil;
    NBPhoneNumber* phoneNumber = [phoneUtil parse:normalizedPhoneNumber defaultRegion:regionCode error:&err];
    
    if (!phoneNumber) {
        ALog(@"<ERROR> Unable to format phone number correctly\nError: %@\nUser Info:%@", err, err.userInfo);
    }
    
    NSString* formattedNumber = [phoneUtil format:phoneNumber numberFormat:NBEPhoneNumberTypeUNKNOWN error:&err];
    if (!formattedNumber) {
        ALog(@"<ERROR> Unable to format phone number correctly\nError: %@\nUser Info:%@", err, err.userInfo);
    }
    
    return formattedNumber;
}

- (NSString*)numberByRemovingLeadingZerosFromNumber:(NSString*)number
{
    NSString* newNumber = [number copy];
    
    if (newNumber) {
        for (NSUInteger i = 0; i < number.length; i++) {
            if ([number characterAtIndex:i] == '0') {
                newNumber = [number substringFromIndex:(i + 1)];
            } else {
                return newNumber;
            }
        }
    }
    
    return newNumber;
}

@end
