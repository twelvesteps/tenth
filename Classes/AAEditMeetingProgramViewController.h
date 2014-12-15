//
//  AAEditMeetingProgramViewController.h
//  Steps
//
//  Created by Tom on 12/8/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAGroupedTableViewController.h"
#import "Meeting+AAAdditions.h"

@class AAEditMeetingProgramViewController;
@protocol AAEditMeetingProgramViewControllerDelegate <NSObject>

- (void)programViewDidSelectProgramType:(AAEditMeetingProgramViewController*)controller;

@end

@interface AAEditMeetingProgramViewController : AAGroupedTableViewController

@property (nonatomic) AAMeetingProgram program;

@property (nonatomic, weak) id<AAEditMeetingProgramViewControllerDelegate> programDelegate;

@end
