//
//  AAMeetingFormatView.h
//  Steps
//
//  Created by Tom on 12/11/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting+AAAdditions.h"

#define FORMAT_VIEW_HEIGHT  23.0f

@interface AAMeetingFormatView : UIView

@property (nonatomic) AAMeetingFormat format;

+ (CGFloat)widthForFormat:(AAMeetingFormat)format;

@end
