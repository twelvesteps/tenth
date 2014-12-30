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

#define AA_EDIT_MEETING_PROPERTY_FORMAT_IDENTIFIER      @"editFormat"
#define AA_EDIT_MEETING_PROPERTY_PROGRAM_IDENTIFIER     @"editProgram"
#define AA_EDIT_MEETING_PROPERTY_LOCATION_IDENTIFIER    @"editLocation"

/**
 *  The AAEditMeetingPropertyDelegate interacts with the 
 *  AAEditMeetingPropertyViewController to update a given meeting property.
 *
 *  Each subclass of AAEditMeetingPropertyDelegate specializes in vending cells
 *  and updating the values of a given meeting property.
 *
 *  AAEditMeetingPropertyDelegate is an abstract class and should never be 
 *  instantiated directly. All instance methods calls will result in an
 *  NSInternalInconsistencyException being thrown.
 */
@interface AAEditMeetingPropertyTableViewDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Meeting* meeting;

+ (instancetype)meetingPropertyDelegateWithIdentifier:(NSString*)identifier;

- (AASeparatorTableViewCell*)separatorCellForIndexPath:(NSIndexPath*)indexPath;

- (BOOL)shouldContinueUpdatingProperty;

- (void)updateMeetingPropertyWithIndexPaths:(NSArray*)indexPaths;

@end
