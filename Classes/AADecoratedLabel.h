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


@interface AADecoratedLabel : UIView

/**-----------------------------------------------------------------------------
 *  @name Setting the decoration view
 *------------------------------------------------------------------------------
 */

/**
 *  The view to be displayed adjacent to the receiver's text
 */
@property (nonatomic, weak) UIView* decorationView; // default is nil


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
@property (nonatomic, strong) UIFont* font; // default is [UIFont systemFontOfSize:13.0f]

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
@property (nonatomic) UIEdgeInsets insets; // default is zero

/**
 *  The alignment of the text displayed by the receiver
 */
@property (nonatomic) AATextAlignment textAlignment; // default is AATextAlignmentLeft

/**
 *  The alignment of the decoration view relative to the receiver's displayed text
 */
@property (nonatomic) AADecorationAlignment decorationAlignment; // default is AATextAlignmentLeft

@end
