//
//  AAEditMeetingViewController.h
//  Steps
//
//  Created by Tom on 11/29/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAGroupedTableViewController.h"
#import "Meeting.h"

@class Meeting;
@class AAEditMeetingViewController;
@protocol AAEditMeetingViewControllerDelegate <NSObject>

// info: Informs the delegate that the user tapped the cancel button
- (void)viewControllerDidCancel:(AAEditMeetingViewController*)vc;

// info:        Informs the delegate that the user has finished editing the meeting
// returns:     void, check the view controller's meeting property
- (void)viewControllerDidFinish:(AAEditMeetingViewController*)vc;

@end

@interface AAEditMeetingViewController : AAGroupedTableViewController

/**
 *  The meeting property that should be selected when the edit screen loads. The
 *  associated control will be made visible or assume first responder status.
 *
 *  The currently recognized values for this property are:
 *  @"title" - The title field attains first responder status
 *  @"location" - The location field attains first responder status
 *  @"startDate" - The start time field displays its date picker
 *  Assigning other values will have no effect.
 *
 *  This value should be set before the controller is displayed or it will have
 *  no effect.
 */
@property (strong, nonatomic) NSString* selectedMeetingProperty;

/**
 *  The meeting being edited. If this value is nil after the controller's view
 *  is loaded the controller will create a new meeting for this property.
 */
@property (strong, nonatomic) Meeting* meeting;

/**
 *  The delegate to receive messages about the controller's status
 */
@property (weak, nonatomic) id<AAEditMeetingViewControllerDelegate> delegate;

@end
