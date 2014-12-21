//
//  MeetingDescriptor+Create.h
//  Steps
//
//  Created by Tom on 12/20/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "MeetingDescriptor.h"

@class MeetingFormat;
@interface MeetingDescriptor (Create)

+ (MeetingDescriptor*)meetingDescriptorWithEntityName:(NSString*)name
                                                title:(NSString*)title
                               inManagedObjectContext:(NSManagedObjectContext*)context;

@end
