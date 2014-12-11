//
//  UIColor+AAAdditions.m
//  Steps
//
//  Created by tom on 6/20/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "UIColor+AAAdditions.h"
#import "Meeting+AAAdditions.h"

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

#define UIColorWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f  green:g/255.0f  blue:b/255.0f alpha:a/255.0f]
#define UIColorWithRGB(r, g, b)     [UIColor colorWithRed:r/255.0f  green:g/255.0f  blue:b/255.0f alpha:1.0f]

+ (UIColor*)stepsBlueColor
{
    return [[UIColor stepsColorMap] objectForKey:STEPS_BLUE_COLOR];
}

+ (UIColor*)stepsRedColor
{
    return [[UIColor stepsColorMap] objectForKey:STEPS_RED_COLOR];
}

+ (UIColor*)stepsOrangeColor
{
    return [[UIColor stepsColorMap] objectForKey:STEPS_ORANGE_COLOR];
}

+ (UIColor*)stepsGreenColor
{
    return [[UIColor stepsColorMap] objectForKey:STEPS_GREEN_COLOR];
}

+ (UIColor*)stepsPurpleColor
{
    return [[UIColor stepsColorMap] objectForKey:STEPS_PURPLE_COLOR];
}

+ (UIColor*)stepsTableViewCellSeparatorColor
{
    return UIColorWithRGB(207.0f, 207.0f, 207.0f);
}


+ (UIColor*)stepsColorForKey:(NSString *)key
{
    return [[UIColor stepsColorMap] objectForKey:key];
}

+ (NSDictionary*)stepsColorMap
{
    static NSDictionary* colorMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        colorMap = @{ STEPS_BLUE_COLOR      : UIColorWithRGB(11.0f, 97.0f, 254.0f),
                      STEPS_RED_COLOR       : UIColorWithRGB(0xFC, 0x00, 0x12),
                      STEPS_GREEN_COLOR     : UIColorWithRGB(0x1D, 0xD2, 0x00),
                      STEPS_ORANGE_COLOR    : UIColorWithRGB(0xFF, 0xA5, 0x00),
                      STEPS_PURPLE_COLOR    : UIColorWithRGB(192.0f, 82.0f, 221.0f)};
    });
    
    return colorMap;
}

@end
