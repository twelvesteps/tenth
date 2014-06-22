//
//  AAInterceptTouchesView.m
//  Steps
//
//  Created by tom on 6/22/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//
#import "AAInterceptTouchesView.h"

@implementation AAInterceptTouchesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//- (void)incrementRectTouchCount:(CGRect)rect inDictionary:(NSMutableDictionary*)dictionary
//{
//    NSValue* rectValue = [NSValue valueWithCGRect:rect];
//    NSNumber* count = [dictionary objectForKey:rectValue];
//
//    if (!count) {
//        count = [NSNumber numberWithInteger:1];
//    } else {
//        count = [NSNumber numberWithInteger:[count integerValue] + 1];
//    }
//    
//    [dictionary setObject:count forKey:rectValue];
//}
//
//- (NSInteger)touchCountForRect:(CGRect)rect inDictionary:(NSDictionary*)dictionary
//{
//    NSValue* rectValue = [NSValue valueWithCGRect:rect];
//    NSNumber* count = [dictionary objectForKey:rectValue];
//    if (!count) {
//        return 0;
//    } else {
//        return [count integerValue];
//    }
//}
//
//- (NSDictionary*)touchCountsInRects:(NSSet*)touches
//{
//    NSMutableDictionary* touchCounts = [[NSMutableDictionary alloc] init];
//    
//    for (UITouch* touch in touches) {
//        BOOL touchInIgnoreRect = NO;
//        CGPoint touchPoint = [touch locationInView:self];
//        DLog(@"<DEBUG> Touch In Point: %@", NSStringFromCGPoint(touchPoint));
//
//        for (NSValue* rectValue in self.ignoreRects) {
//            CGRect ignoreRect = [rectValue CGRectValue];
//            DLog(@"<DEBUG> Ignore Touches Rect: %@", NSStringFromCGRect(ignoreRect));
//
//            if (CGRectContainsPoint(ignoreRect, touchPoint)) {
//                DLog(@"<DEBUG> IgnoreRect contains point");
//                [self incrementRectTouchCount:ignoreRect inDictionary:touchCounts];
//                touchInIgnoreRect = YES;
//            }
//        }
//        
//        if (!touchInIgnoreRect) {
//            DLog(@"<DEBUG> Touch point outside of ignore rects");
//            [self incrementRectTouchCount:self.bounds inDictionary:touchCounts];
//        }
//    }
//    
//    return [touchCounts copy];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSDictionary* touchCounts = [self touchCountsInRects:touches];
//    NSInteger numTouchesOutsideIgnoreRects = [self touchCountForRect:self.bounds inDictionary:touchCounts];
//    if (numTouchesOutsideIgnoreRects >= 1) {
//        DLog(@"<DEBUG> Touch occurred outside of ignore rects, calling delegate method");
//        [self.delegate interceptTouchesView:self didInterceptTouches:touches];
//    } else {
//        DLog(@"<DEBUG> Touch occurred inside of ignore rects, passing to next responder %@", self.nextResponder);
//        [self.nextResponder touchesBegan:touches withEvent:event];
//    }
    [self.delegate interceptTouchesView:self didInterceptTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
