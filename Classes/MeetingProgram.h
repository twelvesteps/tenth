//
//  MeetingProgram.h
//  Steps
//
//  Created by Tom on 12/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Meeting;

@interface MeetingProgram : NSManagedObject

@property (nonatomic, retain) NSString * shortTitle;
@property (nonatomic, retain) NSNumber * symbolType;
@property (nonatomic, retain) NSSet *meetings;
@end

@interface MeetingProgram (CoreDataGeneratedAccessors)

- (void)addMeetingsObject:(Meeting *)value;
- (void)removeMeetingsObject:(Meeting *)value;
- (void)addMeetings:(NSSet *)values;
- (void)removeMeetings:(NSSet *)values;

@end
