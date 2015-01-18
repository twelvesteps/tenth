//
//  AASelectMeetingPropertyViewController.h
//  Steps
//
//  Created by Tom on 12/30/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAGroupedTableViewController.h"

@class Meeting;

@interface AASelectMeetingPropertyViewController : AAGroupedTableViewController

/**
 *  Determines whether the controller is in editing mode
 */
@property (nonatomic, getter=isEditing) BOOL editing;

/**
 *  The meeting to select properties for
 */
@property (nonatomic, strong) Meeting* meeting;

@end
