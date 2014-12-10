//
//  Meeting.h
//  Steps
//
//  Created by Tom on 12/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meeting : NSManagedObject

@property (nonatomic, retain) NSDate * duration;
@property (nonatomic, retain) NSNumber * userIsChairPerson;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * program;
@property (nonatomic, retain) NSNumber * isOpen;
@property (nonatomic, retain) NSString * literature;
@property (nonatomic, retain) NSNumber * format;
@property (nonatomic, retain) NSString * details;

@end
