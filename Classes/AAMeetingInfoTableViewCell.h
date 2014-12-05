//
//  AAMeetingInfoTableViewCell.h
//  Steps
//
//  Created by Tom on 11/27/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"

@interface AAMeetingInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) Meeting* meeting;

+ (CGFloat)heightForCell:(AAMeetingInfoTableViewCell*)cell;

@end