//
//  AAUserSettingsManager.h
//  Steps
//
//  Created by Tom on 12/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meeting+AAAdditions.h"

// *** USER SETTINGS ***
// info:    The following keys are used for accessing user settings
#define AA_USER_SETTING_ADDRESS_BOOK_NOTIFICATION   @"AddressBook"
#define AA_USER_SETTING_LOCK_SCREEN_NOTIFICATION    @"LockScreen"
#define AA_USER_SETTING_MEETING_COLORS_NOTIFICATION @"MeetingColorsMap"

@interface AAUserSettingsManager : NSObject

+ (instancetype)sharedManager;

// contains the colors chosen by the user to represent different meeting formats
@property (strong, nonatomic, readonly) NSDictionary* meetingColorsMap; // returns nil if no preference has been set

- (void)setColor:(UIColor*)color forMeetingFormat:(AAMeetingFormat)format;



@end
