//
//  AAUserSettingsManager.m
//  Steps
//
//  Created by Tom on 12/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserSettingsManager.h"
#import "AAUserMeetingsManager.h"
#import "UIColor+AAAdditions.h"

#define AA_USER_SETTING_MEETING_COLORS_MAP_KEY          @"MeetingColorsMap" // NSDictionary
#define AA_USER_SETTING_DEFAULT_COLOR_KEY               @"DefaultColor" // NSString
#define AA_USER_SETTING_DEFAULT_MEETING_FORMAT_KEY      @"DefaultFormat" // uuid string
#define AA_USER_SETTING_DEFAULT_MEETING_PROGRAM_KEY     @"DefaultProgram" // uuid string
#define AA_USER_SETTING_MEETING_FORMATS_KEY             @"MeetingFormats" // NSArray
#define AA_USER_SETTING_MEETING_PROGRAMS_KEY            @"MeetingPrograms" // NSArray

@interface AAUserSettingsManager()

@property (nonatomic, strong, readwrite) NSDictionary* meetingColorsMap;

@end

@implementation AAUserSettingsManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager
{
    static AAUserSettingsManager* sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[AAUserSettingsManager alloc] init];
    });
    
    return sharedManager;
}


#pragma mark - Properties

- (NSDictionary*)meetingColorsMap
{
    if (_meetingColorsMap) {
        _meetingColorsMap = [self loadMeetingColorsMap];
    }
    
    return _meetingColorsMap;
}


#pragma mark - Colors

- (NSDictionary*)loadMeetingColorsMap
{
    NSDictionary* colorsMap = [[NSUserDefaults standardUserDefaults] objectForKey:AA_USER_SETTING_MEETING_COLORS_MAP_KEY];
    
    if (!colorsMap) {
        colorsMap = nil;
    }
    
    return colorsMap;
}

- (UIColor*)defaultColor
{
    return [UIColor stepsBlueColor];
}

- (UIColor*)colorForFormat:(MeetingFormat *)format
{
    return [UIColor stepsBlueColor];
}


#pragma mark - Default Meeting Settings

- (MeetingProgram*)defaultMeetingProgram
{
    NSString* programID = [[NSUserDefaults standardUserDefaults] objectForKey:AA_USER_SETTING_DEFAULT_MEETING_FORMAT_KEY];
    
    if (!programID) {
        programID = [self setDefaultMeetingProgram];
    }
    
    MeetingProgram* program = [[AAUserMeetingsManager sharedManager] fetchMeetingProgramWithIdentifier:programID];
    
    return program;
}

- (NSString*)setDefaultMeetingProgram
{
    MeetingProgram* defaultProgram = [[AAUserMeetingsManager sharedManager] meetingProgramWithTitle:@"Alcoholics Anonymous"];
    [[NSUserDefaults standardUserDefaults] setObject:defaultProgram.identifier forKey:AA_USER_SETTING_DEFAULT_MEETING_PROGRAM_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return defaultProgram.identifier;
}

@end
