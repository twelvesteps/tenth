//
//  AAEditMeetingPropertyTableViewDelegate.h
//  Steps
//
//  Created by Tom on 12/30/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AASeparatorTableViewCell.h"
#import "Meeting+AAAdditions.h"

#define AA_EDIT_MEETING_PROPERTY_FORMAT_IDENTIFIER      @"Format"
#define AA_EDIT_MEETING_PROPERTY_PROGRAM_IDENTIFIER     @"Program"
#define AA_EDIT_MEETING_PROPERTY_LOCATION_IDENTIFIER    @"Location"

/**
 *  The AAEditMeetingPropertyDelegate interacts with the 
 *  AAEditMeetingPropertyViewController to update a given meeting property.
 *
 *  Each subclass of AAEditMeetingPropertyDelegate specializes in vending cells
 *  and updating the values of a given meeting property. The values of the 
 *  meeting property will be automatically updated as the user interacts with
 *  the cells provided by the delegate.
 *
 *  Any changes made to a meeting object will not be made persistent by the 
 *  delegate. Changes must be saved by another object if they are to persist.
 *
 *  @warning AAEditMeetingPropertyDelegate is an abstract class and should never 
 *  be instantiated. All instance methods calls will result in an
 *  NSInternalInconsistencyException being thrown. 
 *
 *  @warning Throws an NSInternalInconsistencyException if the delegate's 
 *  tableView property has been set and the required protocol methods for 
 *  UITableViewDelegate and UITableViewDataSource have not been implemented by
 *  a subclass.
 */
@interface AAEditMeetingPropertyTableViewDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

/**
 *  The table view that makes calls to the delegate.
 */
@property (nonatomic, weak) UITableView* tableView;

/**
 *  The Meeting object that is being edited by the delegate
 */
@property (nonatomic, strong) Meeting* meeting;

/**
 *  Creates an appropriate concrete object for the given identifier.
 *
 *  @param identifier Describes the type of delegate object to be created. If 
 *  the identifier does not match one of the AA_EDIT_MEETING_PROPERTY macros 
 *  defined above no object will be returned.
 *  @param meeting  The meeting to be edited by the delegate.
 *
 *  @return A property delegate subclass matching the given identifier.
 */
+ (instancetype)meetingPropertyDelegateWithIdentifier:(NSString*)identifier meeting:(Meeting*)meeting;

@end
