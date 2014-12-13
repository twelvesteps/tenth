//
//  AAMeetingLabel.h
//  Steps
//
//  Created by Tom on 12/12/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting+AAAdditions.h"

@interface AAMeetingLabel : UIView

@property (nonatomic) BOOL leftCircle;
@property (nonatomic) AAMeetingFormat format;

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* textColor;

+ (CGFloat)heightForText:(NSString*)text boundingSize:(CGSize)boundingSize;
+ (CGFloat)widthForText:(NSString*)text boundingSize:(CGSize)boundingSize;
+ (CGFloat)widthForText:(NSString *)text boundingSize:(CGSize)boundingSize font:(UIFont*)font;

@end
