//
//  AAUserMeetingsManager.h
//  Steps
//
//  Created by Tom on 12/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAUserDataManager.h"
#import "Meeting.h"
#import "Location.h"
#import "MeetingFormat.h"
#import "MeetingProgram.h"

/**
 *  The AAUserMeetingsManager provides an interface for creating, fetching, and
 *  removing meetings and associated objects.
 */
@interface AAUserMeetingsManager : AAUserDataManager

/**-----------------------------------------------------------------------------
 *  @name Access Meetings Manager Instance
 *------------------------------------------------------------------------------
 */
/**
 *  Returns the singleton instance of AAUserMeetingsManager
 *
 *  @return The shared instance of AAUserMeetingsManager
 */
+ (instancetype)sharedManager;

/**-----------------------------------------------------------------------------
 *  @name Create Meetings and Meeting Descriptors
 *------------------------------------------------------------------------------
 */
/**
 *  Creates a new meeting with the following default property values:
 *  Start Time: The current time and day adjusted to the nearest half hour
 *  Duration: One Hour
 *  Program: The User's default meeting program
 *
 *  @return A new meeting object with default values set for its properties
 */
- (Meeting*)createMeeting;

/**
 *  Fetches the location with the given title or creates it if it doesn't exist
 *  already
 *
 *  @param title The title of the meeting format to fetch or create. If 'nil'
 *  the method returns 'nil'
 *
 *  @return A Location object with the given title or 'nil' if no title was 
 *  provided
 */
- (Location*)locationWithTitle:(NSString*)title;

/**
 *  Fetches the meeting format with the given title or creates it if it doesn't
 *  exist already.
 *
 *  @param title The title of the meeting format to fetch or create. If 'nil' 
 *  the method returns 'nil'.
 *
 *  @return A MeetingFormat object with the given title or 'nil' if no title
 *  was provided
 */
- (MeetingFormat*)meetingFormatWithTitle:(NSString*)title;

/**
 *  Fetches the meeting program with the given title or creates it if it doesn't
 *  exist already
 *
 *  @param title The title of the meeting program to fetch or create. If 'nil'
 *  the method returns 'nil'
 *
 *  @return A meeting program object with the given title or 'nil' if no title
 *  was provided
 */
- (MeetingProgram*)meetingProgramWithTitle:(NSString*)title;

/**-----------------------------------------------------------------------------
 *  @name Fetch Meetings, Formats and Programs
 *------------------------------------------------------------------------------
 */
/**
 *  Fetches all the user's meetings
 *
 *  @return An array of all the user's meetings sorted by start date
 */
- (NSArray*)fetchMeetings;

/**
 *  Fetches all the available meeting locations
 *
 *  @return An array of the available meeting formats sorted by most recently
 *  modified.
 */
- (NSArray*)fetchLocations;

/**
 *  Fetches all the available meeting formats
 *
 *  @return An array of the available meeting formats sorted alphabetically
 */
- (NSArray*)fetchMeetingFormats;

/**
 *  Fetches all the available meeting programs
 *
 *  @return An array of the available meeting programs sorted alphabetically
 */
- (NSArray*)fetchMeetingPrograms;

/**
 *  Fetches the meeting format with the given identifier
 *
 *  @param identifier A lower case UUID of the format to be fetched
 *
 *  @return The format with the given identifier or 'nil' if no matching format 
 *  could be found
 */
- (MeetingFormat*)fetchMeetingFormatWithIdentifier:(NSString*)identifier;

/**
 *  Fetches the meeting program with the given identifier.
 *
 *  @param identifier A lower case UUID of the program to be fetched
 *
 *  @return The program with the given identifier or 'nil' if no matching 
 *  program could be found
 */
- (MeetingProgram*)fetchMeetingProgramWithIdentifier:(NSString*)identifier;

/**-----------------------------------------------------------------------------
 *  @name Remove Meetings, Formats and Programs
 *------------------------------------------------------------------------------
 */
/**
 *  Removes the given meeting from the object graph
 *
 *  @param meeting The meeting to be removed
 */
- (void)removeMeeting:(Meeting*)meeting;

/**
 *  Removes the given meeting format from the object graph
 *
 *  @param format The meeting format to be removed
 */
- (void)removeMeetingFormat:(MeetingFormat*)format;

/**
 *  Removes the given meeting program from the object graph
 *
 *  @param program The meeting program to be removed
 */
- (void)removeMeetingProgram:(MeetingProgram*)program;

/**-----------------------------------------------------------------------------
 *  @name Default Meeting Program
 *------------------------------------------------------------------------------
 */
/**
 *  Returns the default meeting program for newly created meetings as defined
 *  by the user. If no default meeting program has been set by the user then
 *  Alcoholics Anonymous is the fallback
 *
 *  @return The default meeting program defined by the user
 */
- (MeetingProgram*)defaultMeetingProgram;

/**
 *  Sets the given meeting program as the default for the user
 *
 *  @param program The meeting program to be set as the default. If 'nil' is
 *  passed the default program will reset to Alcoholics Anonymous
 */
- (void)setDefaultMeetingProgram:(MeetingProgram*)program;

@end
