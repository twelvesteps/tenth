#import "_Entity.h"

@interface Entity : _Entity {}
// Custom logic goes here.

/**
 *  All subclasses of Entity that override awakeFromInsert should call Entity's
 *  implementation somewhere within this method.
 */
- (void)awakeFromInsert;
@end
