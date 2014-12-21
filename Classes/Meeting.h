//
//  Meeting.h
//  Steps
//
//  Created by Tom on 12/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MeetingFormat;

@interface Meeting : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSDate * duration;
@property (nonatomic, retain) NSNumber * isOpen;
@property (nonatomic, retain) NSString * literature;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *programs;
@property (nonatomic, retain) NSSet *formats;
@end

@interface Meeting (CoreDataGeneratedAccessors)

- (void)addProgramsObject:(NSManagedObject *)value;
- (void)removeProgramsObject:(NSManagedObject *)value;
- (void)addPrograms:(NSSet *)values;
- (void)removePrograms:(NSSet *)values;

- (void)addFormatsObject:(MeetingFormat *)value;
- (void)removeFormatsObject:(MeetingFormat *)value;
- (void)addFormats:(NSSet *)values;
- (void)removeFormats:(NSSet *)values;

@end
