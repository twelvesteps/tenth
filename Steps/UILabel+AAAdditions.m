//
//  UILabel+AAAdditions.m
//  Steps
//
//  Created by Tom on 12/4/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "UILabel+AAAdditions.h"
#import "UIColor+AAAdditions.h"
#import <objc/runtime.h>

@implementation UILabel (AAAdditions)

// Code was copied from Aaron on StackOverflow
// http://stackoverflow.com/questions/18807940/can-i-change-the-font-color-of-the-datepicker-in-ios7

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setTextColor:)
                      withNewSelector:@selector(swizzledSetTextColor:)];
        [self swizzleInstanceSelector:@selector(willMoveToSuperview:)
                      withNewSelector:@selector(swizzledWillMoveToSuperview:)];
        //[self swizzleInstanceSelector:@selector(setText:)
        //              withNewSelector:@selector(swizzledSetTextColor:)];
    });
}

// Forces the text colour of the label to be white only for UIDatePicker and its components
-(void) swizzledSetTextColor:(UIColor *)textColor {
    if([self view:self hasSuperviewOfClass:[UIDatePicker class]] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerWeekMonthDayView")] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerContentView")]){
        [self swizzledSetTextColor:[UIColor stepsBlueColor]];
    } else {
        //Carry on with the default
        [self swizzledSetTextColor:textColor];
    }
}

// Some of the UILabels haven't been added to a superview yet so listen for when they do.
- (void) swizzledWillMoveToSuperview:(UIView *)newSuperview {
    [self swizzledSetTextColor:self.textColor];
    [self swizzledWillMoveToSuperview:newSuperview];
}

- (void) swizzledSetText:(NSString*)text
{
    [self swizzledSetTextColor:self.textColor];
    [self swizzledSetText:text];
}

// -- helpers --
- (BOOL) view:(UIView *) view hasSuperviewOfClass:(Class) class {
    if(view.superview){
        if ([view.superview isKindOfClass:class]){
            return true;
        }
        return [self view:view.superview hasSuperviewOfClass:class];
    }
    return false;
}

+ (void) swizzleInstanceSelector:(SEL)originalSelector
                 withNewSelector:(SEL)newSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    BOOL methodAdded = class_addMethod([self class],
                                       originalSelector,
                                       method_getImplementation(newMethod),
                                       method_getTypeEncoding(newMethod));
    
    if (methodAdded) {
        class_replaceMethod([self class],
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@end
