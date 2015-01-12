//
//  AAEditMeetingPropertyViewFactory.h
//  Steps
//
//  Created by Tom on 1/12/15.
//  Copyright (c) 2015 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AABarButtonActionType) {
    AABarButtonActionTypeAdd,
    AABarButtonActionTypeEdit,
    AABarButtonActionTypeCancel,
    AABarButtonActionTypeConfirm,
};

@class MeetingDescriptor;
@class AAMeetingDescriptorTableViewCell;

@interface AAEditMeetingPropertyViewFactory : NSObject

/**-----------------------------------------------------------------------------
 *  @name Create Meeting Descriptor Table View Cells
 *------------------------------------------------------------------------------
 */

/**
 *  Returns an AAMeetingDescriptorTableViewCell for the given descriptor with
 *  its views initialized. This method does not alter the frame of the cell
 *  or its subviews
 *
 *  @param tableView    The table view to degueue a reusable cell from
 *  @param descriptor   The descriptor that will be used in the cell. This value
 *                      should not be nil
 *  @param reuseID      The reuse identifier for the desired cell. If this value
 *                      is nil the default values will be used
 *
 *  @return A meeting descriptor cell with its decorated label intialized
 */
+ (AAMeetingDescriptorTableViewCell*)tableView:(UITableView*)tableView meetingDescriptorCellForDescriptor:(MeetingDescriptor*)descriptor reuseIdentifier:(NSString*)reuseID;

/**
 *  Similar to tableView:meetingDescriptorCellForDescriptor:reuseIdentifier,
 *  except that it does not attempt to dequeue a reusable cell. A new cell is
 *  always instantiated.
 *
 *  @param descriptor The descriptor to be used in the cell. This value should 
 *                    not be nil
 *
 *  @return A meeting descriptor cell with its decorated label initialized.
 */
+ (AAMeetingDescriptorTableViewCell*)meetingDescriptorCellForDescriptor:(MeetingDescriptor*)descriptor;


/**-----------------------------------------------------------------------------
 *  @name Create Bar Button Items
 *------------------------------------------------------------------------------
 */

/**
 *  Creates a new UIBarButtonItem for the corresponding action, but does not 
 *  add any target action methods to the button.
 *
 *  @param type The type of action performed by the bar button item. This will
 *
 *  @return A bar button corresponding to the style defined for the given action
 */
+ (UIBarButtonItem*)stepsBarButtonItemForAction:(AABarButtonActionType)type;

/**
 *  Creates a new UIBarButtonItem with the given target action and adds it to
 *  the given navigation bar
 *
 *  @param type   The target action for the bar btuton
 *  @param bar    The nagivation bar to place the button within
 *  @param left   Determines whether the button should be placed on the left or
 *                right of the navigation bar
 *  @param action The target action to perform on touch up inside events
 *
 *  @return The bar button item that was created and wired
 */
+ (UIBarButtonItem*)stepsBarButtonItemForAction:(AABarButtonActionType)type
                                inNavigationBar:(UINavigationBar*)bar
                                       leftSide:(BOOL)left
                               witHTargetAction:(SEL)action;



@end
