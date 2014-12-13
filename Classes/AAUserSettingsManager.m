//
//  AAUserSettingsManager.m
//  Steps
//
//  Created by Tom on 12/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserSettingsManager.h"
#import "UIColor+AAAdditions.h"

#define AA_USER_SETTING_MEETING_FORMAT_COLOR_MAP_KEY    @"MeetingsColorMap"

@interface AAUserSettingsManager()

@property (nonatomic, strong, readwrite) NSDictionary* meetingColorsMap;

@end

@implementation AAUserSettingsManager


+ (instancetype)sharedManager
{
    static AAUserSettingsManager* sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[AAUserSettingsManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Colors

@synthesize meetingColorsMap = _meetingColorsMap;

- (NSDictionary*)meetingColorsMap
{
    if (!_meetingColorsMap) {
        _meetingColorsMap = [self userDefaultsMeetingColorsMap];
    }
    
    return _meetingColorsMap;
}

- (UIColor*)defaultColor
{
    return [self colorForMeetingFormat:AAMeetingFormatUnspecified];
}

- (UIColor*)colorForMeetingFormat:(AAMeetingFormat)format
{
    NSString* colorKey = [self.meetingColorsMap objectForKey:[Meeting plistKeyForMeetingFormat:format]];
    return [UIColor stepsColorForKey:colorKey];
}

- (void)setMeetingColorsMap:(NSDictionary *)meetingColorsMap
{
    _meetingColorsMap = meetingColorsMap;
    [[NSNotificationCenter defaultCenter] postNotificationName:AA_USER_SETTING_MEETING_COLORS_NOTIFICATION object:meetingColorsMap];
}

- (NSDictionary*)userDefaultsMeetingColorsMap
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* colorMap = [defaults objectForKey:AA_USER_SETTING_MEETING_FORMAT_COLOR_MAP_KEY];
    
    if (!colorMap) {
        colorMap = [self defaultColorMap];
        [defaults setObject:colorMap forKey:AA_USER_SETTING_MEETING_FORMAT_COLOR_MAP_KEY];
        [defaults synchronize];
    }
    
    return colorMap;
}

- (void)setColor:(NSString*)name forMeetingFormat:(AAMeetingFormat)format
{
    NSMutableDictionary* meetingColorsMap = [self.meetingColorsMap mutableCopy];
    [meetingColorsMap setObject:name forKey:[Meeting plistKeyForMeetingFormat:format]];
    
    self.meetingColorsMap = [meetingColorsMap copy];
    [self synchronizeColorsMap];
}

- (void)synchronizeColorsMap
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.meetingColorsMap forKey:AA_USER_SETTING_MEETING_FORMAT_COLOR_MAP_KEY];
    [defaults synchronize];
}

- (NSDictionary*)defaultColorMap
{
    return @{ [Meeting plistKeyForMeetingFormat:AAMeetingFormatUnspecified] : STEPS_BLUE_COLOR,
              [Meeting plistKeyForMeetingFormat:AAMeetingFormatBeginner]    : STEPS_GREEN_COLOR,
              [Meeting plistKeyForMeetingFormat:AAMeetingFormatDiscussion]  : STEPS_ORANGE_COLOR,
              [Meeting plistKeyForMeetingFormat:AAMeetingFormatLiterature]  : STEPS_BLUE_COLOR,
              [Meeting plistKeyForMeetingFormat:AAMeetingFormatSpeaker]     : STEPS_RED_COLOR,
              [Meeting plistKeyForMeetingFormat:AAMeetingFormatStepStudy]   : STEPS_PURPLE_COLOR};
}


#pragma mark - Default Meeting Settings

- (AAMeetingProgram)defaultProgram
{
    return AAMeetingProgramAA;
}

- (AAMeetingFormat)defaultFormat
{
    return AAMeetingFormatUnspecified;
}

@end
