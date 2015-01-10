//
//  AAUserMeetingsManager.m
//  Steps
//
//  Created by Tom on 12/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserMeetingsManager.h"

#import "UIColor+AAAdditions.h"
#import "NSDate+AAAdditions.h"

#define DEFAULT_MEETING_PROGAM_KEY              @"DefaultMeetingProgram"

#define AA_MEETING_PROGRAM_AA_TITLE             @"Alcoholics Anonymous"
#define AA_MEETING_PROGRAM_NA_TITLE             @"Narcotics Anonymous"
#define AA_MEETING_PROGRAM_ALANON_TITLE         @"Alanon"
#define AA_MEETING_PROGRAM_ALATEEN_TITLE        @"Alateen"

#define AA_MEETING_PROGRAM_AA_SHORT_TITLE       @"AA"
#define AA_MEETING_PROGRAM_NA_SHORT_TITLE       @"NA"
#define AA_MEETING_PROGRAM_ALANON_SHORT_TITLE   @""
#define AA_MEETING_PROGRAM_ALATEEN_SHORT_TITLE  @""

#define AA_MEETING_FORMAT_LITERATURE_TITLE      @"Literature"
#define AA_MEETING_FORMAT_SPEAKER_TITLE         @"Speaker"
#define AA_MEETING_FORMAT_DISCUSSION_TITLE      @"Discussion"
#define AA_MEETING_FORMAT_STEP_STUDY_TITLE      @"Step Study"
#define AA_MEETING_FORMAT_BEGINNER_TITLE        @"Beginner"
#define AA_MEETING_FORMAT_MEDITATION_TITLE      @"Meditation"

@interface AAUserMeetingsManager()

@property (nonatomic, strong) NSArray* defaultMeetingFormats;
@property (nonatomic, strong) NSArray* defaultMeetingPrograms;

@end

@implementation AAUserMeetingsManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager
{
    static AAUserMeetingsManager* sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        [sharedManager loadDefaultMeetingFormats];
        [sharedManager loadDefaultMeetingPrograms];
    });
    
    return sharedManager;
}

- (void)loadDefaultMeetingFormats
{
    for (NSString* title in [AAUserMeetingsManager defaultMeetingFormatTitles]) {
        MeetingFormat* format = [self meetingFormatWithTitle:title ];

        format.colorKey = [[AAUserMeetingsManager defaultMeetingFormatColorKeys] objectForKey:title];
    }
}

- (void)loadDefaultMeetingPrograms
{
    NSArray* programTitles = [AAUserMeetingsManager defaultMeetingProgramTitles];
    NSArray* programShortTitles = [AAUserMeetingsManager defaultMeetingProgramShortTitles];
    NSArray* programSymbolTypes = [AAUserMeetingsManager defaultMeetingProgramSymbolTypes];
    for (NSInteger i = 0; i < programTitles.count; i++) {
        MeetingProgram* program = [self meetingProgramWithTitle:programTitles[i] localizeTitle:YES];
        program.shortTitle = programShortTitles[i];
        program.symbolType = programSymbolTypes[i];
    }
}

+ (NSArray*)defaultMeetingFormatTitles
{
    
    return @[AA_MEETING_FORMAT_LITERATURE_TITLE,
             AA_MEETING_FORMAT_SPEAKER_TITLE,
             AA_MEETING_FORMAT_DISCUSSION_TITLE,
             AA_MEETING_FORMAT_STEP_STUDY_TITLE,
             AA_MEETING_FORMAT_BEGINNER_TITLE,
             AA_MEETING_FORMAT_MEDITATION_TITLE];
}

+ (NSDictionary*)defaultMeetingFormatColorKeys
{
    return @{AA_MEETING_FORMAT_LITERATURE_TITLE : STEPS_BLUE_COLOR,
             AA_MEETING_FORMAT_SPEAKER_TITLE    : STEPS_ORANGE_COLOR,
             AA_MEETING_FORMAT_DISCUSSION_TITLE : STEPS_RED_COLOR,
             AA_MEETING_FORMAT_STEP_STUDY_TITLE : STEPS_PURPLE_COLOR,
             AA_MEETING_FORMAT_BEGINNER_TITLE   : STEPS_GREEN_COLOR,
             AA_MEETING_FORMAT_MEDITATION_TITLE : STEPS_YELLOW_COLOR,};
}

+ (NSArray*)defaultMeetingProgramTitles
{
    
    return @[AA_MEETING_PROGRAM_AA_TITLE,
             AA_MEETING_PROGRAM_NA_TITLE,
             AA_MEETING_PROGRAM_ALANON_TITLE,
             AA_MEETING_PROGRAM_ALATEEN_TITLE];
}

+ (NSArray*)defaultMeetingProgramShortTitles
{
    return @[AA_MEETING_PROGRAM_AA_SHORT_TITLE,
             AA_MEETING_PROGRAM_NA_SHORT_TITLE,
             AA_MEETING_PROGRAM_ALANON_SHORT_TITLE,
             AA_MEETING_PROGRAM_ALATEEN_SHORT_TITLE];
}

+ (NSArray*)defaultMeetingProgramSymbolTypes
{
    return @[@(AAMeetingProgramSymbolTypeCircleAroundTriangle), // Alcoholics Anyonmous
             @(AAMeetingProgramSymbolTypeCircleAroundTriangle), // Narcotics Anonymous
             @(AAMeetingProgramSymbolTypeTriangleAroundCircle), // Alanon
             @(AAMeetingProgramSymbolTypeTriangleAroundCircle),]; // Alateen
}


#pragma mark - Creating Objects

- (Meeting*)createMeeting
{
    Meeting* meeting = [NSEntityDescription insertNewObjectForEntityForName:[Meeting entityName]
                                                     inManagedObjectContext:self.managedObjectContext];
    meeting.startDate = [self defaultMeetingStartDate];
    meeting.duration = [NSDate oneHour];
        
    meeting.program = [self defaultMeetingProgram];
    
    return meeting;
}

- (NSDate*)defaultMeetingStartDate
{
    return [[NSDate date] nearestHalfHour];
}

- (Location*)locationWithTitle:(NSString *)title
{
    return (Location*)[Location meetingDescriptorWithEntityName:[Location entityName]
                                                          title:title
                                                  localizeTitle:NO
                                         inManagedObjectContext:self.managedObjectContext];
}

- (MeetingFormat*)meetingFormatWithTitle:(NSString *)title
{
    return [self meetingFormatWithTitle:title localizeTitle:NO];
}

- (MeetingFormat*)meetingFormatWithTitle:(NSString *)title localizeTitle:(BOOL)localize
{
    return (MeetingFormat*)[MeetingFormat meetingDescriptorWithEntityName:[MeetingFormat entityName]
                                                                    title:title
                                                            localizeTitle:localize
                                                   inManagedObjectContext:self.managedObjectContext];
}

- (MeetingProgram*)meetingProgramWithTitle:(NSString *)title
{
    return [self meetingProgramWithTitle:title localizeTitle:NO];
}

- (MeetingProgram*)meetingProgramWithTitle:(NSString *)title localizeTitle:(BOOL)localize
{
    return (MeetingProgram*)[MeetingProgram meetingDescriptorWithEntityName:[MeetingProgram entityName] title:title localizeTitle:localize inManagedObjectContext:self.managedObjectContext];
}


- (MeetingProgram*)defaultMeetingProgram
{
    NSString* defaultProgramID = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_MEETING_PROGAM_KEY];
    MeetingProgram* defaultProgram = [self fetchMeetingProgramWithIdentifier:defaultProgramID];
    
    if (defaultProgramID) {
        return defaultProgram;
    } else {
        return [self meetingProgramWithTitle:AA_MEETING_PROGRAM_AA_TITLE];
    }
}

- (void)setDefaultMeetingProgram:(MeetingProgram *)program
{
    NSString* defaultProgramID = program.identifier;
    [[NSUserDefaults standardUserDefaults] setObject:defaultProgramID forKey:DEFAULT_MEETING_PROGAM_KEY];
}


#pragma mark - Removing Objects

- (void)removeMeeting:(Meeting *)meeting
{
    [self.managedObjectContext deleteObject:meeting];
}

- (void)removeMeetingFormat:(MeetingFormat *)format
{
    [self.managedObjectContext deleteObject:format];
}

- (void)removeMeetingProgram:(MeetingProgram *)program
{
    [self.managedObjectContext deleteObject:program];
}


#pragma mark - Fetching Objects

- (NSArray*)fetchMeetings
{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
    NSArray* meetings = [self fetchItemsForEntityName:[Meeting entityName]
                                  withSortDescriptors:@[sortByDate]
                                        withPredicate:nil];
    return meetings;
}

- (NSArray*)fetchMeetingFormats
{
    return [self fetchMeetingDescriptorsWithEntityName:[MeetingFormat entityName]];
}

- (NSArray*)fetchMeetingPrograms
{
    return [self fetchMeetingDescriptorsWithEntityName:[MeetingProgram entityName]];
}

- (NSArray*)fetchMeetingDescriptorsWithEntityName:(NSString*)name
{
    NSSortDescriptor* sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSArray* descriptors = [self fetchItemsForEntityName:name
                                     withSortDescriptors:@[sortByTitle]
                                           withPredicate:nil];
    
    return descriptors;
}

- (MeetingFormat*)fetchMeetingFormatWithIdentifier:(NSString *)identifier
{
    return (MeetingFormat*)[self fetchMeetingDescriptorWithName:[MeetingFormat entityName] identifier:identifier];
}

- (MeetingProgram*)fetchMeetingProgramWithIdentifier:(NSString *)identifier
{
    return (MeetingProgram*)[self fetchMeetingDescriptorWithName:[MeetingProgram entityName] identifier:identifier];
}

- (MeetingDescriptor*)fetchMeetingDescriptorWithName:(NSString*)name identifier:(NSString*)identifier
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    NSArray* results = [self fetchItemsForEntityName:name withSortDescriptors:nil withPredicate:predicate];
    
    if (results.count == 1) {
        return [results lastObject];
    } else if (results.count == 0) {
        return nil;
    } else {
        DLog(@"<DEBUG> Multiple %@s fetched with matching identifier", name);
        return nil;
    }
}




@end
