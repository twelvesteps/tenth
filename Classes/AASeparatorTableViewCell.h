//
//  AASeparatorTableViewCell.h
//  Steps
//
//  Created by Tom on 12/8/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEPARATOR_HEIGHT    0.5f
#define SEPARATOR_INSET     16.0f

@interface AASeparatorTableViewCell : UITableViewCell

@property (nonatomic) BOOL topSeparator;
@property (nonatomic) BOOL bottomSeparator;

@property (nonatomic) NSInteger separatorsCount;
@property (strong, nonatomic) NSArray* separatorOrigins;

@end
