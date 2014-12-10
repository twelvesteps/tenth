//
//  AAMeetingSectionDividerView.m
//  Steps
//
//  Created by Tom on 12/5/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAMeetingSectionDividerView.h"
#import "UIFont+AAAdditions.h"

@implementation AAMeetingSectionDividerView

#pragma mark - Lifecycle and Properties

#define OBSERVE_TITLE_LABEL_TEXT_KEY_PATH   @"text"

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    [self initTitleLabel];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)initTitleLabel
{
    UILabel* titleLabel = [[UILabel alloc] init];
    
    titleLabel.font = [UIFont stepsSubheaderFont];
    
    [titleLabel addObserver:self forKeyPath:OBSERVE_TITLE_LABEL_TEXT_KEY_PATH options:0 context:nil];
    
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
}

- (void)dealloc
{
    [self.titleLabel removeObserver:self forKeyPath:OBSERVE_TITLE_LABEL_TEXT_KEY_PATH];
}


#pragma mark - Key Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:OBSERVE_TITLE_LABEL_TEXT_KEY_PATH]) {
        [self setNeedsLayout];
    }
}


#pragma mark - Layout

#define LEADING_MARGIN_PADDING  14.0f

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutTitleLabel];
}

- (void)layoutTitleLabel
{
    [self.titleLabel sizeToFit];
    
    CGRect titleLabelFrame = self.titleLabel.frame;
    
    titleLabelFrame.origin = CGPointMake(self.bounds.origin.x + LEADING_MARGIN_PADDING,
                                         CGRectGetMidY(self.bounds) - titleLabelFrame.size.height / 2.0f);
    self.titleLabel.frame = titleLabelFrame;
}
@end