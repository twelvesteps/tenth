

#import "MeetingDescriptor.h"
#import "MeetingProgram.h"
#import "MeetingFormat.h"
#import "Location.h"

@interface MeetingDescriptor ()

// Private interface goes here.

@end

@implementation MeetingDescriptor

#pragma mark - Lifecycle

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // UUID spec claims identifier should be lower case
    self.identifier = [[[NSUUID UUID] UUIDString] lowercaseString];
}

+ (MeetingDescriptor*)meetingDescriptorWithEntityName:(NSString*)name
                                                title:(NSString*)title
                                        localizeTitle:(BOOL)localize
                               inManagedObjectContext:(NSManagedObjectContext*)context
{
    if (![self validateMeetingDescriptorEntityName:name]) {
        DLog(@"<DEBUG> Unrecognized meeting descriptor entity name: %@", name);
        return nil;
    }
    
    // fetch any existing descriptors
    NSArray* results = [self fetchMeetingDescriptorsWithEntityName:name
                                                             title:title
                                                         inContext:context];
    
    if (results.count == 1) {
        DLog(@"<DEBUG> Meeting descriptor found");
        return [results firstObject];
    } else if (results.count == 0) {
        DLog(@"<DEBUG> No meeting descriptor with title: %@, creating...", title);
        MeetingDescriptor* descriptor = [self createMeetingDescriptorWithEntityname:name
                                                                              title:title
                                                                      localizeTitle:localize
                                                             inManagedObjectContext:context];
        return descriptor;
    } else {
        DLog(@"<DEBUG> Multiple formats exist with the title: %@", title);
        return nil;
    }
}

+ (BOOL)validateMeetingDescriptorEntityName:(NSString*)name
{
    if ([name isEqualToString:[MeetingProgram entityName]] ||
        [name isEqualToString:[MeetingFormat entityName]] ||
        [name isEqualToString:[Location entityName]]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSArray*)fetchMeetingDescriptorsWithEntityName:(NSString*)name
                                            title:(NSString*)title
                                        inContext:(NSManagedObjectContext*)context
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:name];
    NSPredicate* titlePredicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    request.predicate = titlePredicate;
    
    NSError* err;
    NSArray* results = [context executeFetchRequest:request error:&err];
    
    return results;
}

+ (MeetingDescriptor*)createMeetingDescriptorWithEntityname:(NSString*)name
                                                      title:(NSString*)title
                                              localizeTitle:(BOOL)localize
                                     inManagedObjectContext:(NSManagedObjectContext*)context
{
    MeetingDescriptor* descriptor = (MeetingDescriptor*)[NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
    descriptor.title = title;
    descriptor.localizeTitleValue = localize; // default value
    
    return descriptor;
}


#pragma mark - Properties

- (void)setIdentifier:(NSString*)identifier
{
    [self willChangeValueForKey:MeetingDescriptorAttributes.identifier];
    [self setPrimitiveIdentifier:identifier];
    [self didChangeValueForKey:MeetingDescriptorAttributes.identifier];
}

- (void)setLocalizeTitleValue:(BOOL)localizeTitle
{
    [self willChangeValueForKey:MeetingDescriptorAttributes.localizeTitle];
    [self setPrimitiveLocalizeTitleValue:localizeTitle];
    [self didChangeValueForKey:MeetingDescriptorAttributes.localizeTitle];
}

- (NSString*)localizedTitle
{
    if (self.localizeTitleValue) {
        return NSLocalizedString(self.title, @"Localized descriptor title");
    } else {
        return self.title;
    }
}

@end
