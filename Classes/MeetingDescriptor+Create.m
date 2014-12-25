//
//  MeetingDescriptor+Create.m
//  Steps
//
//  Created by Tom on 12/20/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "MeetingDescriptor+Create.h"
#import "AAUserMeetingsManager.h"
@interface MeetingDescriptor()

@property (nonatomic, retain, readwrite) NSString* identifier;

@end

@implementation MeetingDescriptor (Create)

+ (MeetingDescriptor*)meetingDescriptorWithEntityName:(NSString*)name
                                                title:(NSString*)title
                               inManagedObjectContext:(NSManagedObjectContext*)context
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:name];
    NSPredicate* titlePredicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    request.predicate = titlePredicate;
    
    NSError* err;
    NSArray* results = [context executeFetchRequest:request error:&err];
    
    if (results.count == 1) {
        return [results firstObject];
    } else if (results.count == 0) {
        MeetingDescriptor* descriptor = (MeetingDescriptor*)[NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
        descriptor.title = title;
        descriptor.identifier = [[[NSUUID UUID] UUIDString] lowercaseString];
        
        return descriptor;
    } else {
        DLog(@"<DEBUG> Multiple formats with the given title already exist");
        return nil;
    }
}


@end
