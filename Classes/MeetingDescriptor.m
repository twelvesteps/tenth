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

- (void)setIdentifier:(NSString*)identifier
{
    [self willChangeValueForKey:MeetingDescriptorAttributes.identifier];
    [self setPrimitiveIdentifier:identifier];
    [self didChangeValueForKey:MeetingDescriptorAttributes.identifier];
}

@end
