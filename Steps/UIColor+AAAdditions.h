//
//  UIColor+AAAdditions.h
//  Steps
//
//  Created by tom on 6/20/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Meeting;
@interface UIColor (AAAdditions)

- (NSArray*)numberValues; // A single NSNumber containing the RGB values for the color

+ (UIColor*)colorFromNumbers:(NSArray*)numbers;

// info:    If color is nil [UIColor blackColor] will be called.
//          If alpha is outside of the range [0.0, 1.0], the closest acceptable value will be used.
// returns: Returns a UIColor with the same RGB values as color and the given alpha
// use:     UIColor* transparentGreen = [UIColor colorWithUIColor:[UIColor greenColor] withAlpha:0.8f];

+ (UIColor*)colorWithUIColor:(UIColor*)color withAlpha:(CGFloat)alpha;

+ (UIColor*)stepsBlueColor;
+ (UIColor*)stepsRedColor;
+ (UIColor*)stepsOrangeColor;
+ (UIColor*)stepsGreenColor;
+ (UIColor*)stepsPurpleColor;

+ (UIColor*)stepsTableViewCellSeparatorColor;
@end
