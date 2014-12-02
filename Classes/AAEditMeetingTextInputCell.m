//
//  AAEditMeetingTextInputCell.m
//  Steps
//
//  Created by Tom on 11/29/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingTextInputCell.h"
@interface AAEditMeetingTextInputCell()

@property (nonatomic, weak) UIView* separatorView;

@end

@implementation AAEditMeetingTextInputCell

#define SEPARATOR_VIEW_HEIGHT   1.0f

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView* separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 31.0f, self.bounds.size.width, SEPARATOR_VIEW_HEIGHT)];
    separatorView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.separatorView = separatorView;
    [self.contentView addSubview:separatorView];
}

@end
