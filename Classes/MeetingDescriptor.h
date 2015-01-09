#import "_MeetingDescriptor.h"

@interface MeetingDescriptor : _MeetingDescriptor {}

/**
 *  Creates a new meeting descriptor with the given entity type and title or
 *  returns a descriptor with the given entity type and title if it already
 *  exsits.
 *
 *  @param name     The name of the entity to be created. Must be a valid child
 *                  entity of MeetingDescriptor.
 *  @param title    The title for returned descriptor.
 *  @param localize Determines whether the descriptor's title should be 
 *                  localized. This value is ignored if a descriptor with the
 *                  given title already exists.
 *  @param context  The managed object context to insert the descriptor into.
 *
 *  @return A MeetingDescriptor child entity matching the entity name and title
 */
+ (MeetingDescriptor*)meetingDescriptorWithEntityName:(NSString*)name
                                                title:(NSString*)title
                                        localizeTitle:(BOOL)localize
                               inManagedObjectContext:(NSManagedObjectContext*)context;

/**
 *  Returns the localized title of the descriptor if localzieTitle is YES or
 *  the unlocalized title if localizeTitle is NO
 *
 *  @return A possibly localized title according to the descriptor's
 *          localizeTitle value.
 */
- (NSString*)localizedTitle;

@end
