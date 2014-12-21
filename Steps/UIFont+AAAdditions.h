//
//  UIFont+AAAdditions.h
//  Steps
//
//  Created by Tom on 12/2/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (AAAdditions)

+ (UIFont*)stepsHeaderFont;
+ (UIFont*)stepsSubheaderFont;
+ (UIFont*)stepsCaptionFont;
+ (UIFont*)stepsBodyFont;
+ (UIFont*)stepsFooterFont;

+ (UIFont*)stepsCompressedFont:(NSUInteger)compression; // maximum allowed compression is 3

@end
