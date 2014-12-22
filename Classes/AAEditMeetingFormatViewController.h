//
//  AAEditMeetingFormatViewController.h
//  Steps
//
//  Created by Tom on 12/22/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAGroupedTableViewController.h"
#import "MeetingFormat.h"

@class AAEditMeetingFormatViewController;
@protocol AAEditMeetingFormatViewControllerDelegate <NSObject>

- (void)formatViewDidSelectFormatType:(AAEditMeetingFormatViewController*)controller;

@end

@interface AAEditMeetingFormatViewController : AAGroupedTableViewController

@property (nonatomic, strong) MeetingFormat* format;

@property (nonatomic, weak) id<AAEditMeetingFormatViewControllerDelegate>formatDelegate;

@end
