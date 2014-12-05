//
//  AAEditMeetingTextInputCell.m
//  Steps
//
//  Created by Tom on 11/29/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingTextInputCell.h"
#import "UIFont+AAAdditions.h"

@interface AAEditMeetingTextInputCell()

@property (nonatomic, weak) UIView* separatorView;

@end

@implementation AAEditMeetingTextInputCell

#define SEPARATOR_VIEW_HEIGHT   1.0f
#define CELL_HEIGHT             44.0f

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView* separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                     CELL_HEIGHT - SEPARATOR_VIEW_HEIGHT,
                                                                     self.bounds.size.width,
                                                                     SEPARATOR_VIEW_HEIGHT)];
    
    separatorView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.separatorView = separatorView;
    [self.contentView addSubview:separatorView];
    
    self.textField.font = [UIFont stepsCaptionFont];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutSeparatorView];
}

- (void)layoutSeparatorView
{
    CGRect separatorViewFrame = CGRectMake(0.0f,
                                           CELL_HEIGHT - SEPARATOR_VIEW_HEIGHT,
                                           self.bounds.size.width,
                                           SEPARATOR_VIEW_HEIGHT);
    self.separatorView.frame = separatorViewFrame;
}

@end
