//
//  AAUserSettingsManager.h
//  Steps
//
//  Created by Tom on 12/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meeting+AAAdditions.h"
#import "MeetingFormat.h"
#import "MeetingProgram.h"

// *** USER SETTINGS ***
#define AA_USER_SETTING_ADDRESS_BOOK_NOTIFICATION   @"AddressBookAccessChanged"
#define AA_USER_SETTING_LOCK_SCREEN_NOTIFICATION    @"LockScreenChanged"
#define AA_USER_SETTING_MEETING_COLORS_NOTIFICATION @"MeetingColorsMapChanged"

@interface AAUserSettingsManager : NSObject

+ (instancetype)sharedManager;

- (MeetingProgram*)defaultMeetingProgram;

@end
