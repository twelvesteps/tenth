//
//  AASeparatorTableViewCell.m
//  Steps
//
//  Created by Tom on 12/8/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AASeparatorTableViewCell.h"
#import "UIColor+AAAdditions.h"
@interface AASeparatorTableViewCell()

@property (strong, nonatomic) NSArray* separatorViews;

@end

@implementation AASeparatorTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initSeparators];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSeparators];        
    }
    
    return self;
}

- (void)setBottomSeparator:(BOOL)bottomSeparator
{
    _bottomSeparator = bottomSeparator;
    [self updateSeparators];
}

- (void)updateSeparators
{
    [self clearSeparators];
    [self initSeparators];
}

- (void)clearSeparators
{
    for (UIView* separatorView in self.separatorViews) {
        [separatorView removeFromSuperview];
    }
    
    self.separatorViews = nil;
}

- (void)initSeparators
{
    NSMutableArray* separators = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.separatorsCount; i++) {
        UIView* separatorView = [[UIView alloc] init];
        
        separatorView.backgroundColor = [UIColor stepsTableViewCellSeparatorColor];
        [self insertSubview:separatorView atIndex:0];
        [separators addObject:separatorView];
    }
    
    self.separatorViews = [separators copy];
}

- (NSInteger)separatorsCount
{
    if (self.bottomSeparator) {
        return 1;
    } else {
        return 0;
    }
}

- (NSArray*)separatorOrigins
{
    return @[[NSValue valueWithCGPoint:CGPointMake(self.bounds.origin.x + SEPARATOR_INSET, self.bounds.size.height - SEPARATOR_HEIGHT)]];
}


#pragma mark - Layout
#define SEPARATOR_HEIGHT    0.5f

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutSeparators];
}

- (void)layoutSeparators
{
    for (NSInteger i = 0; i < self.separatorsCount; i++) {
        UIView* separatorView = self.separatorViews[i];
        NSValue* separatorOriginValue = self.separatorOrigins[i];
        CGPoint separatorOrigin = [separatorOriginValue CGPointValue];
        
        CGRect separatorViewFrame = CGRectMake(separatorOrigin.x,
                                               separatorOrigin.y,
                                               self.bounds.size.width - separatorOrigin.x,
                                               SEPARATOR_HEIGHT);
        
        separatorView.frame = separatorViewFrame;
    }
}

@end
