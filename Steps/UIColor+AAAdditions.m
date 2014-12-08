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

#define UIColorWithRGB(r, g, b)     [UIColor colorWithRed:r/255.0f  green:g/255.0f  blue:b/255.0f alpha:1.0f];

+ (UIColor*)stepsBlueColor
{
    return UIColorWithRGB(11.0f, 97.0f, 254.0f);
}

+ (UIColor*)stepsRedColor
{
    return UIColorWithRGB(0xFF, 0x0D, 0x00);
}

+ (UIColor*)stepsOrangeColor
{
    return UIColorWithRGB(0xFF, 0xA5, 0x00);
}

+ (UIColor*)stepsGreenColor
{
    return UIColorWithRGB(0x00, 0xFE, 0x1F);
}

+ (UIColor*)stepsTableViewCellSeparatorColor
{
    return UIColorWithRGB(207.0f, 207.0f, 207.0f);
}

@end
