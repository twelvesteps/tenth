//
//  MeetingType.h
//  Steps
//
//  Created by Tom on 11/28/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Meeting;

@interface MeetingType : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *meetings;

@end

@interface MeetingType (CoreDataGeneratedAccessors)

- (void)addMeetingsObject:(Meeting *)value;
- (void)removeMeetingsObject:(Meeting *)value;
- (void)addMeetings:(NSSet *)values;
- (void)removeMeetings:(NSSet *)values;

@end
