

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
                                            error:(NSError**)err
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:name];
    NSPredicate* titlePredicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    request.predicate = titlePredicate;
    
    NSArray* results = [context executeFetchRequest:request error:err];
    
    return results;
}

+ (MeetingDescriptor*)createMeetingDescriptorWithEntityName:(NSString*)name
                                                      title:(NSString*)title
                                              localizeTitle:(BOOL)localize
                                     inManagedObjectContext:(NSManagedObjectContext*)context
{
    MeetingDescriptor* descriptor = (MeetingDescriptor*)[NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
    descriptor.title = title;
    descriptor.localizeTitle = @(localize);
    
    return descriptor;
}


#pragma mark - Properties

- (void)setIdentifier:(NSString*)identifier
{
    [self willChangeValueForKey:MeetingDescriptorAttributes.identifier];
    [self setPrimitiveIdentifier:identifier];
    [self didChangeValueForKey:MeetingDescriptorAttributes.identifier];
}

- (void)setLocalizeTitle:(NSNumber*)localizeTitle
{
    [self willChangeValueForKey:MeetingDescriptorAttributes.localizeTitle];
    [self setPrimitiveLocalizeTitle:localizeTitle];
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
