#import "_MeetingDescriptor.h"

@interface MeetingDescriptor : _MeetingDescriptor {}

+ (MeetingDescriptor*)meetingDescriptorWithEntityName:(NSString*)name
                                                title:(NSString*)title
                                        localizeTitle:(BOOL)localize
                               inManagedObjectContext:(NSManagedObjectContext*)context;

- (NSString*)localizedTitle;

@end
