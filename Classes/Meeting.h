//
//  Meeting.h
//  Steps
//
//  Created by Tom on 11/28/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MeetingType;

@interface Meeting : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * duration; // hours and minutes
@property (nonatomic, retain) NSNumber * isChairPerson;
@property (nonatomic, retain) NSDate * startDate; // contains weekday and time information only
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *types;
@end

@interface Meeting (CoreDataGeneratedAccessors)

- (void)addTypesObject:(MeetingType *)value;
- (void)removeTypesObject:(MeetingType *)value;
- (void)addTypes:(NSSet *)values;
- (void)removeTypes:(NSSet *)values;

@end
