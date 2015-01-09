#import "MeetingDescriptor.h"

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
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:name];
    NSPredicate* titlePredicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    request.predicate = titlePredicate;
    
    NSError* err;
    NSArray* results = [context executeFetchRequest:request error:&err];
    
    if (results.count == 1) {
        DLog(@"<DEBUG> Meeting descriptor found");
        return [results firstObject];
    } else if (results.count == 0) {
        MeetingDescriptor* descriptor = (MeetingDescriptor*)[NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
        descriptor.title = title;
        descriptor.localizeTitleValue = localize; // default value
        
        return descriptor;
    } else {
        DLog(@"<DEBUG> Multiple formats with the given title already exist");
        return nil;
    }
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
    return NSLocalizedString(self.title, @"Localized descriptor title");
}

@end
