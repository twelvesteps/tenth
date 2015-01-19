#import "_MeetingDescriptor.h"

@interface MeetingDescriptor : _MeetingDescriptor {}

/**
 *  Creates a new meeting descriptor with the given entity type and title
 *
 *  @param name     The name of the entity to be created. Must be a valid child
 *                  entity of MeetingDescriptor.
 *  @param title    The title for the new descriptor
 *  @param localize Determines whether the descriptor's title should be 
 *                  localized
 *  @param context  The managed object context to insert the descriptor into.
 *
 *  @return A MeetingDescriptor child entity matching the entity name and title
 *          or nil if the entity name does not describe a valid child entity
 */
+ (MeetingDescriptor*)createMeetingDescriptorWithEntityName:(NSString*)name
                                                      title:(NSString*)title
                                              localizeTitle:(BOOL)localize
                                     inManagedObjectContext:(NSManagedObjectContext*)context;

/**
 *  Determines whether the given name describes a valid child entity. Override
 *  this method in order to extend the number of child entities that can be 
 *  created using 
 *  meetingDescriptorWithEntityName:title:localizeTitle:inManagedObjectContext:
 *
 *  @param name The entity name to be validated
 *
 *  @return YES if the name describes a valid child entity, NO otherwise
 */
+ (BOOL)validateMeetingDescriptorEntityName:(NSString*)name;

/**
 *  Returns the localized title of the descriptor if localzieTitle is YES or
 *  the unlocalized title if localizeTitle is NO
 *
 *  @return A possibly localized title according to the descriptor's
 *          localizeTitle value.
 */
- (NSString*)localizedTitle;

@end
