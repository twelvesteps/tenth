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

#define RED_INDEX   0
#define GREEN_INDEX 1
#define BLUE_INDEX  2
#define ALPHA_INDEX 3

- (NSArray*)numberValues
{
    const float* colors = CGColorGetComponents(self.CGColor);
    size_t numComponents = CGColorGetNumberOfComponents(self.CGColor);
    
    NSMutableArray* mutableNumberValues = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < numComponents; i++) {
        [mutableNumberValues addObject:@(colors[i])];
    }
    
    return [mutableNumberValues copy];
}

+ (UIColor*)colorFromNumbers:(NSArray *)numbers
{
    NSNumber* redNumber = numbers[RED_INDEX];
    NSNumber* greenNumber = numbers[GREEN_INDEX];
    NSNumber* blueNumber = numbers[BLUE_INDEX];
    NSNumber* alphaNumber;
    if (numbers.count > ALPHA_INDEX) {
        alphaNumber = numbers[ALPHA_INDEX];
    } else {
        alphaNumber = @(1.0f);
    }
    
    CGFloat redValue = redNumber.floatValue;
    CGFloat greenValue = greenNumber.floatValue;
    CGFloat blueValue = blueNumber.floatValue;
    CGFloat alphaValue = alphaNumber.floatValue;

    return [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:alphaValue];
}

+ (UIColor*)colorWithUIColor:(UIColor *)color withAlpha:(CGFloat)alpha
{
    if (!color) color = [UIColor blackColor];
    if (alpha < 0.0f) alpha = 0.0f;
    if (alpha > 1.0f) alpha = 1.0f;
    
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

#define UIColorWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f  green:g/255.0f  blue:b/255.0f alpha:a/255.0f];
#define UIColorWithRGB(r, g, b)     [UIColor colorWithRed:r/255.0f  green:g/255.0f  blue:b/255.0f alpha:1.0f];

+ (UIColor*)stepsBlueColor
{
    return UIColorWithRGB(11.0f, 97.0f, 254.0f);
}

+ (UIColor*)stepsRedColor
{
    return UIColorWithRGB(0xFC, 0x00, 0x12);
}

+ (UIColor*)stepsOrangeColor
{
    return UIColorWithRGB(0xFF, 0xA5, 0x00);
}

+ (UIColor*)stepsGreenColor
{
    return UIColorWithRGB(0x20, 0xE9, 0x00);
}

+ (UIColor*)stepsPurpleColor
{
    return UIColorWithRGB(192.0f, 82.0f, 221.0f);
}

+ (UIColor*)stepsTableViewCellSeparatorColor
{
    return UIColorWithRGB(207.0f, 207.0f, 207.0f);
}

@end
