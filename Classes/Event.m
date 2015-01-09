#import "Event.h"

@interface Event ()

// Private interface goes here.

@end

@implementation Event

#pragma mark - Lifecycle

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // UUID spec claims identifier should be lower case
    self.identifier = [[[NSUUID UUID] UUIDString] lowercaseString];
}

- (void)setIdentifier:(NSString*)identifier
{
    [self willChangeValueForKey:EventAttributes.identifier];
    [self setPrimitiveIdentifier:identifier];
    [self didChangeValueForKey:EventAttributes.identifier];
}

@end
