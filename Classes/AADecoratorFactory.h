//
//  AADecoratorFactory.h
//  Steps
//
//  Created by Tom on 1/18/15.
//  Copyright (c) 2015 spitzgoby LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MeetingDescriptor;
@class AAMeetingDescriptorDecorationView;

@interface AADecoratorFactory : NSObject

/**
 *  Creates a decoration view for the given descriptor with its default frame 
 *  already set. For example the AAMeetingFormatCircleDecorationView has a 
 *  default frame of {x: 0, y: 0, width: 10, height: 10}
 *
 *  @param descriptor The meeting descriptor requiring decoration
 *
 *  @return The newly created decoration view
 */
- (AAMeetingDescriptorDecorationView*)decoratorForMeetingDescriptor:(MeetingDescriptor*)descriptor;

/**
 *  Creates a decoration view for the given descriptor with its frame set to the
 *  given value.
 *
 *  @param descriptor The meeting descriptor requiring decoration
 *  @param frame      The frame for the view
 *
 *  @return The newly created decoration view
 */
- (AAMeetingDescriptorDecorationView*)decoratorForMeetingDescriptor:(MeetingDescriptor *)descriptor withFrame:(CGRect)frame;

@end
