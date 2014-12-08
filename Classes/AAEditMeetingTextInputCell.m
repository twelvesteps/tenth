//
//  AAEditMeetingTextInputCell.m
//  Steps
//
//  Created by Tom on 11/29/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingTextInputCell.h"
#import "UIFont+AAAdditions.h"
#import "UIColor+AAAdditions.h"

@interface AAEditMeetingTextInputCell()

@end

@implementation AAEditMeetingTextInputCell

#define SEPARATOR_VIEW_HEIGHT   0.5f
#define CELL_HEIGHT             44.0f

- (void)awakeFromNib
{
    self.topSeparator = YES;
    
    [super awakeFromNib];
    
    self.textField.font = [UIFont stepsCaptionFont];

}

- (NSInteger)separatorsCount
{
    if (self.topSeparator) {
        return 2;
    } else {
        return 1;
    }
}

- (NSArray*)separatorOrigins
{
    if (self.topSeparator) {
        return @[[NSValue valueWithCGPoint:CGPointMake(self.bounds.origin.x, self.bounds.origin.y)],
                 [NSValue valueWithCGPoint:CGPointMake(self.bounds.origin.x + SEPARATOR_INSET, self.bounds.size.height - SEPARATOR_HEIGHT)]];
    } else {
        return @[[NSValue valueWithCGPoint:CGPointMake(self.bounds.origin.x, self.bounds.size.height - SEPARATOR_HEIGHT)]];
    }
}


@end
