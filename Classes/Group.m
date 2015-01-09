#import "Group.h"

@interface Group ()

// Private interface goes here.

@end

@implementation Group

#pragma mark - Lifecycle

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // UUID spec claims identifier should be lower case
    self.identifier = [[[NSUUID UUID] UUIDString] lowercaseString];
}

- (void)setIdentifier:(NSString*)identifier
{
    [self willChangeValueForKey:GroupAttributes.identifier];
    [self setPrimitiveIdentifier:identifier];
    [self didChangeValueForKey:GroupAttributes.identifier];
}

@end
