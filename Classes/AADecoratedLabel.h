//
//  AADecoratedLabel.h
//  Steps
//
//  Created by Tom on 12/27/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  These constants determine the horizontal alignment of a decoration view
 *  relative to adjacent text.
 */
typedef NS_ENUM(NSInteger, AADecorationAlignment) {
    /**
     *  Decoration view is aligned to the left of the text
     */
    AADecorationAlignmentLeft,
    /**
     *  Decoration view is aligned to the right of the text
     */
    AADecorationAlignmentRight,
};

/**
 *  These constants determine the horizontal alignment of text
 */
typedef NS_ENUM(NSInteger, AATextAlignment){
    /** 
     *  Text is aligned to the left of the frame
     */
    AATextAlignmentLeft,
    /** 
     *  Text is aligned in the horizontal center of the frame
     */
    AATextAlignmentCenter,
    /** 
     *  Text is aligned to the right of the frame
     */
    AATextAlignmentRight,
};


/**
 *  The AADecoratedLabel class provides a means to present text together with a
 *  view (the decoration) adjacent. 
 *
 *  The decoration view can be any object that inherits from UIView. The view
 *  will be displayed adjacent to the text according to the label's text and
 *  decoration alignment values.
 *
 *  Example Layout: (with text and decoration left aligned)
 *
 *  ----------------------------------------------------------------------
 *  |-Left Inset-<Decoration View>-Decoration Spacing-<Text>-Right Inset-|
 *  ----------------------------------------------------------------------
 *
 *  @warning The AADecoratedLabel assumes that its frame and the frame of its
 *  decoration view have been set. It has not been tested using autolayout.
 */
@class MeetingDescriptor;
@interface AADecoratedLabel : UIView

/**-----------------------------------------------------------------------------
 *  @name Setting the decoration view
 *------------------------------------------------------------------------------
 */

/**
 *  The view to be displayed adjacent to the receiver's text
 */
@property (nonatomic, weak) UIView* decorationView; // default is nil

/**
 *  Determines whether the decoration view needs to be redrawn in response to 
 *  changes in the receiver's appearance or layout.
 *  Setting this property to YES may result in a performance decrease as the 
 *  decoration view will be completely redrawn.
 */
@property (nonatomic) BOOL redrawDecorationView; // default is NO


/**-----------------------------------------------------------------------------
 *  @name Displaying text
 *------------------------------------------------------------------------------
 */

/**
 *  The text to be displayed by the receiver
 */
@property (nonatomic, strong) NSString* text; // default is nil

/**
 *  The font to use when displaying the receiver's text
 */
@property (nonatomic, strong) UIFont* font; // default is [UIFont systemFontOfSize:15.0f]

/**
 *  The color to use when displaying the receiver's text
 */
@property (nonatomic, strong) UIColor* textColor; // default is [UIColor darkTextColor]


/**-----------------------------------------------------------------------------
 *  @name Laying out and aligning text and decoration view
 *------------------------------------------------------------------------------
 */
/**
 *  Determines the horizontal insets of the decoration view and the 
 *  text from the receiver's frame. The top and bottom values are ignored.
 */
@property (nonatomic) UIEdgeInsets insets; // default is UIEdgeInsetsZero

/**
 *  Determines the horizontal distance between the decoration view and the text
 *  of the receiver.
 */
@property (nonatomic) CGFloat decorationSpacing; // default is 8.0f

/**
 *  The alignment of the text displayed by the receiver
 */
@property (nonatomic) AATextAlignment textAlignment; // default is AATextAlignmentLeft

/**
 *  The alignment of the decoration view relative to the receiver's displayed text
 */
@property (nonatomic) AADecorationAlignment decorationAlignment; // default is AATextAlignmentLeft

/**
 *  Returns the size needed to display the receiver with the receiver's current
 *  text and decoration view. The width and height values will be non-negative
 *  and rounded up to the nearest integer.
 *
 *  @param text         The text to be displayed
 *  @param boundingSize The maximum size for the receiver's text
 *
 *  @return The size needed to display the receiver
 */
- (CGSize)sizeWithBoundingSize:(CGSize)boundingSize;

/**-----------------------------------------------------------------------------
 *  @name Factory Methods
 *------------------------------------------------------------------------------
 */

+ (instancetype)decoratedLabelForMeetingDescriptor:(MeetingDescriptor*)descriptor;

@end
