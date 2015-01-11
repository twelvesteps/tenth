//
//  AAMeetingDescriptorTableViewCell.h
//  Steps
//
//  Created by Tom on 1/11/15.
//  Copyright (c) 2015 spitzgoby LLC. All rights reserved.
//

#import "AASeparatorTableViewCell.h"
#import "AADecoratedLabel.h"

@interface AAMeetingDescriptorTableViewCell : AASeparatorTableViewCell

@property (nonatomic, strong) IBOutlet AADecoratedLabel* descriptorLabel;

@end
