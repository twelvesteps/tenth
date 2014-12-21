//
//  MeetingDescriptor.h
//  Steps
//
//  Created by Tom on 12/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MeetingDescriptor : NSManagedObject

@property (nonatomic, retain)            NSString * title;
@property (nonatomic, retain, readonly)  NSString * identifier;
@property (nonatomic, retain)            NSNumber * localizeTitle;

@end
