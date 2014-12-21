//
//  MeetingFormat.h
//  Steps
//
//  Created by Tom on 12/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MeetingDescriptor+Localization.h"

@class Meeting;

@interface MeetingFormat : MeetingDescriptor

@property (nonatomic, retain) NSSet *meetings;
@end

@interface MeetingFormat (CoreDataGeneratedAccessors)

- (void)addMeetingsObject:(Meeting *)value;
- (void)removeMeetingsObject:(Meeting *)value;
- (void)addMeetings:(NSSet *)values;
- (void)removeMeetings:(NSSet *)values;

@end
