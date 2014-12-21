//
//  AAUserMeetingsManager.m
//  Steps
//
//  Created by Tom on 12/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserMeetingsManager.h"
#import "MeetingDescriptor+Create.h"

#define AA_MEETING_ITEM_NAME                    @"Meeting"
#define AA_MEETING_FORMAT_ITEM_NAME             @"MeetingFormat"
#define AA_MEETING_PROGRAM_ITEM_NAME            @"MeetingProgram"

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
        MeetingFormat* format = [self meetingFormatWithTitle:title];
        format.localizeTitle = @(YES);
    }
}

- (void)loadDefaultMeetingPrograms
{
    NSArray* programTitles = [AAUserMeetingsManager defaultMeetingProgramTitles];
    NSArray* programShortTitles = [AAUserMeetingsManager defaultMeetingProgramShortTitles];
    for (NSInteger i = 0; i < programTitles.count; i++) {
        MeetingProgram* program = [self meetingProgramWithTitle:programTitles[i]];
        program.shortTitle = programShortTitles[i];
        program.localizeTitle = @(YES);
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
//    static NSArray* defaultMeetingFormatTitles = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        defaultMeetingFormatTitles = @[AA_MEETING_FORMAT_LITERATURE_TITLE,
//                                       AA_MEETING_FORMAT_SPEAKER_TITLE,
//                                       AA_MEETING_FORMAT_DISCUSSION_TITLE,
//                                       AA_MEETING_FORMAT_STEP_STUDY_TITLE,
//                                       AA_MEETING_FORMAT_BEGINNER_TITLE,
//                                       AA_MEETING_FORMAT_MEDITATION_TITLE];
//    });
//    
//    return defaultMeetingFormatTitles;
}

+ (NSArray*)defaultMeetingProgramTitles
{
    
    return @[AA_MEETING_PROGRAM_AA_TITLE,
             AA_MEETING_PROGRAM_NA_TITLE,
             AA_MEETING_PROGRAM_ALANON_TITLE,
             AA_MEETING_PROGRAM_ALATEEN_TITLE];
//    static NSArray* defaultMeetingProgramTitles = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        defaultMeetingProgramTitles = @[AA_MEETING_PROGRAM_AA_TITLE,
//                                        AA_MEETING_PROGRAM_NA_TITLE,
//                                        AA_MEETING_PROGRAM_ALANON_TITLE,
//                                        AA_MEETING_PROGRAM_ALATEEN_TITLE];
//    });
//    
//    return defaultMeetingProgramTitles;
}

+ (NSArray*)defaultMeetingProgramShortTitles
{
    return @[AA_MEETING_PROGRAM_AA_SHORT_TITLE,
             AA_MEETING_PROGRAM_NA_SHORT_TITLE,
             AA_MEETING_PROGRAM_ALANON_SHORT_TITLE,
             AA_MEETING_PROGRAM_ALATEEN_SHORT_TITLE];
}


#pragma mark - Creating Objects

- (Meeting*)createMeeting
{
    return [NSEntityDescription insertNewObjectForEntityForName:AA_MEETING_ITEM_NAME
                                         inManagedObjectContext:self.managedObjectContext];
}

- (MeetingFormat*)meetingFormatWithTitle:(NSString *)title
{
    return (MeetingFormat*)[MeetingFormat meetingDescriptorWithEntityName:AA_MEETING_FORMAT_ITEM_NAME
                                                                    title:title
                                                   inManagedObjectContext:self.managedObjectContext];
}

- (MeetingProgram*)meetingProgramWithTitle:(NSString *)title
{
    return (MeetingProgram*)[MeetingProgram meetingDescriptorWithEntityName:AA_MEETING_PROGRAM_ITEM_NAME
                                                                      title:title
                                                     inManagedObjectContext:self.managedObjectContext];
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
    NSArray* meetings = [self fetchItemsForEntityName:AA_MEETING_ITEM_NAME
                                  withSortDescriptors:@[sortByDate]
                                        withPredicate:nil];
    return meetings;
}

- (NSArray*)fetchMeetingFormats
{
    NSSortDescriptor* sortByPopularity = [NSSortDescriptor sortDescriptorWithKey:@"meetings.count" ascending:NO];
    NSArray* formats = [self fetchItemsForEntityName:AA_MEETING_FORMAT_ITEM_NAME
                                 withSortDescriptors:nil
                                       withPredicate:nil];
    formats = [formats sortedArrayUsingDescriptors:@[sortByPopularity]];
    
    return formats;
}

- (MeetingFormat*)fetchMeetingFormatWithIdentifier:(NSString *)identifier
{
    return (MeetingFormat*)[self fetchMeetingDescriptorWithName:AA_MEETING_FORMAT_ITEM_NAME identifier:identifier];
}

- (MeetingProgram*)fetchMeetingProgramWithIdentifier:(NSString *)identifier
{
    return (MeetingProgram*)[self fetchMeetingDescriptorWithName:AA_MEETING_PROGRAM_ITEM_NAME identifier:identifier];
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

- (NSArray*)fetchMeetingPrograms
{
    NSArray* programs = [self fetchItemsForEntityName:AA_MEETING_PROGRAM_ITEM_NAME
                                  withSortDescriptors:nil
                                        withPredicate:nil];
    
    return programs;
}


@end
