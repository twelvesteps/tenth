//
//  Meeting.h
//  Steps
//
//  Created by Tom on 11/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meeting : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * types;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * duration;
@property (nonatomic, retain) NSNumber * isChairPerson;

@end
