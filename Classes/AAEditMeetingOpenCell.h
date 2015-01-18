//
//  AAEditMeetingOpenCell.h
//  Steps
//
//  Created by Tom on 12/8/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AASeparatorTableViewCell.h"

@class AAMeetingProgramDecorationView;
@interface AAEditMeetingOpenCell : AASeparatorTableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *openMeetingSwitch;
@property (weak, nonatomic) IBOutlet AAMeetingProgramDecorationView *programDecorationView;

@end
