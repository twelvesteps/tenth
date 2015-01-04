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
    return [UIColor stepsColorForKey:STEPS_BLUE_COLOR];
}

+ (UIColor*)stepsRedColor
{
    return [UIColor stepsColorForKey:STEPS_RED_COLOR];
}

+ (UIColor*)stepsOrangeColor
{
    return [UIColor stepsColorForKey:STEPS_ORANGE_COLOR];
}

+ (UIColor*)stepsGreenColor
{
    return [UIColor stepsColorForKey:STEPS_GREEN_COLOR];
}

+ (UIColor*)stepsYellowColor
{
    return [UIColor stepsColorForKey:STEPS_YELLOW_COLOR];
}

+ (UIColor*)stepsPurpleColor
{
    return [UIColor stepsColorForKey:STEPS_PURPLE_COLOR];
}

+ (UIColor*)stepsTableViewCellSeparatorColor
{
    return UIColorWithRGB(207.0f, 207.0f, 207.0f);
}

+ (UIColor*)stepsColorForKey:(NSString *)key
{
    UIColor* color = [[UIColor stepsColorMap] objectForKey:key];
    if (!color) {
        ALog(@"<DEBUG> Unrecognized color key: %@", key);
    }
    
    return color;
}

+ (NSDictionary*)stepsColorMap
{
    static NSDictionary* colorMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        colorMap = @{ STEPS_BLUE_COLOR      : UIColorWithRGB(0x00, 0xA5, 0xDB), //#00A5DB
                      STEPS_RED_COLOR       : UIColorWithRGB(0xD8, 0x1E, 0x05), //#D81E05
                      STEPS_GREEN_COLOR     : UIColorWithRGB(0xBA, 0xD8, 0x0A), //#BAD80A
                      STEPS_ORANGE_COLOR    : UIColorWithRGB(0xFC, 0xA3, 0x11), //#FCA311
                      STEPS_YELLOW_COLOR    : UIColorWithRGB(0xF9, 0xD6, 0x16), //#F9D616
                      STEPS_PURPLE_COLOR    : UIColorWithRGB(0xA3, 0x07, 0xFF),};
    });
    
    return colorMap;
}

@end
