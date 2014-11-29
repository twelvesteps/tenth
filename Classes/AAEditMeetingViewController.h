//
//  AAEditMeetingViewController.h
//  Steps
//
//  Created by Tom on 11/29/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AATableViewController.h"

@class Meeting;
@class AAEditMeetingViewController;
@protocol AAEditMeetingViewControllerDelegate <NSObject>

// info: Informs the delegate that the user tapped the cancel button
- (void)viewControllerDidCancel:(AAEditMeetingViewController*)vc;

// info:        Informs the delegate that the user has finished editing the meeting
// returns:     void, check the view controller's meeting property
- (void)viewControllerDidFinish:(AAEditMeetingViewController*)vc;

@end

@interface AAEditMeetingViewController : AATableViewController

@property (strong, nonatomic) Meeting* meeting; // default is nil, set to edit an existing meeting
@property (weak, nonatomic) id<AAEditMeetingViewControllerDelegate> delegate;

@end
