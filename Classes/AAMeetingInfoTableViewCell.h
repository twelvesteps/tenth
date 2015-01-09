//
//  AAMeetingInfoTableViewCell.h
//  Steps
//
//  Created by Tom on 11/27/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AASeparatorTableViewCell.h"

@class Meeting;

@interface AAMeetingInfoTableViewCell : AASeparatorTableViewCell

@property (strong, nonatomic) Meeting* meeting;

+ (CGFloat)heightForCell:(AAMeetingInfoTableViewCell*)cell;

@end
