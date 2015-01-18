//
//  AAMeetingTableViewCell.h
//  Steps
//
//  Created by Tom on 11/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"
#import "AASeparatorTableViewCell.h"

@class AAMeetingProgramDecorationView;
@class AAMeetingLabel;
@interface AAMeetingTableViewCell : AASeparatorTableViewCell

@property (strong, nonatomic) Meeting* meeting;

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet AAMeetingProgramDecorationView *programDecorationView;

@end
