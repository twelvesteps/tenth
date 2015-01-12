//
//  AAEditMeetingPropertyTableViewDelegate.h
//  Steps
//
//  Created by Tom on 12/30/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The names that AAEditMeetingPropertyTableViewDelegate can instantiate.
 */
#define AA_EDIT_MEETING_PROPERTY_FORMAT_NAME    @"Format"
#define AA_EDIT_MEETING_PROPERTY_PROGRAM_NAME   @"Program"
#define AA_EDIT_MEETING_PROPERTY_LOCATION_NAME  @"Location"

/**
 *  The default reuse identifier for meeting descriptor cells
 */
#define AA_MEETING_DESCRIPTOR_CELL_REUSE_ID             @"MeetingDescriptorCell"

@class Meeting;

/**
 *  The AAEditMeetingPropertyDelegate interacts with the 
 *  AAEditMeetingPropertyViewController to update a given meeting property.
 *
 *  Each subclass of AAEditMeetingPropertyDelegate specializes in vending cells
 *  and updating the values of a given meeting property. The values of the 
 *  meeting property will be automatically updated as the user interacts with
 *  the cells provided by the delegate.
 *
 *  Each subclass of AAEditMeetingPropertyTableViewDelegate should explicitly 
 *  declare any table view delegate or datasource methods that it implements.
 *  These methods should be forwarded to the delegate by a proxy class, 
 *  typically the view controller presenting the table view.
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
@interface AAEditMeetingPropertyTableViewDelegate : NSObject

/**-----------------------------------------------------------------------------
 *  @name Set Delegate's Meeting Property
 *------------------------------------------------------------------------------
 */
/**
 *  The Meeting object that is being edited by the delegate
 */
@property (nonatomic, strong) Meeting* meeting;

/**
 *  The delegate's current property name
 */
@property (nonatomic, strong, readonly) NSString* propertyName;

/**
 *  Creates an appropriate concrete object for the given name.
 *
 *  @param name Describes the type of delegate object to be created. If 
 *  the name does not match one of the AA_EDIT_MEETING_PROPERTY macros 
 *  defined above no object will be returned.
 *  @param meeting  The meeting to be edited by the delegate.
 *
 *  @return A property delegate subclass matching the given name.
 */
+ (instancetype)meetingPropertyDelegateWithPropertyName:(NSString*)name meeting:(Meeting*)meeting;

/**-----------------------------------------------------------------------------
 *  @name Table View Delegate and Datasource Methods
 *------------------------------------------------------------------------------
 */

/**
 *  The following methods should be implemented by any subclass of the delegate.
 *  Subclasses may also implement additional methods defined in the 
 *  UITableViewDelegate and UITableViewDataSource protocols. 
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView;
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
