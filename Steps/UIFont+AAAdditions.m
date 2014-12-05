//
//  UIFont+AAAdditions.m
//  Steps
//
//  Created by Tom on 12/2/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "UIFont+AAAdditions.h"

@implementation UIFont (AAAdditions)

+ (UIFont*)stepsHeaderFont
{
    return [UIFont boldSystemFontOfSize:19.0f];
}

+ (UIFont*)stepsSubheaderFont
{
    return [UIFont boldSystemFontOfSize:17.0f];
}

+ (UIFont*)stepsCaptionFont
{
    return [UIFont systemFontOfSize:17.0f];
}

+ (UIFont*)stepsBodyFont
{
    return [UIFont systemFontOfSize:16.0f];
}

+ (UIFont*)stepsFooterFont
{
    return [UIFont systemFontOfSize:14.0f];
}
@end
