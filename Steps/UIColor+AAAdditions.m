//
//  UIColor+AAAdditions.m
//  Steps
//
//  Created by tom on 6/20/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "UIColor+AAAdditions.h"

@implementation UIColor (AAAdditions)

+ (UIColor*)colorWithUIColor:(UIColor *)color withAlpha:(CGFloat)alpha
{
    if (!color) color = [UIColor blackColor];
    if (alpha < 0.0f) alpha = 0.0f;
    if (alpha > 1.0f) alpha = 1.0f;
    
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor*)stepsBlueTextColor
{
    return [UIColor colorWithRed:11.0f/255.0f green:96.0f/255.0f blue:254.0f/255.0f alpha:1.0f];
}

@end
