//
//  AAMeetingTableViewCell.h
//  Steps
//
//  Created by Tom on 11/16/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"

@interface AAMeetingTableViewCell : UITableViewCell

@property (strong, nonatomic) Meeting* meeting;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;


@end
