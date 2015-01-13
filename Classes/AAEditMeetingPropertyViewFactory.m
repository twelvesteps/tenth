//
//  AAEditMeetingPropertyViewFactory.m
//  Steps
//
//  Created by Tom on 1/12/15.
//  Copyright (c) 2015 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingPropertyViewFactory.h"

#import "AAMeetingDescriptorTableViewCell.h"
#import "AAMeetingFellowshipIcon.h"
#import "AAMeetingFormatCircleDecorationView.h"

#import "MeetingFormat.h"
#import "MeetingProgram.h"
#import "Location.h"

@implementation AAEditMeetingPropertyViewFactory

#pragma mark - Meeting Descriptor Table View Cells

+ (UIView*)decoratorViewForDescriptor:(MeetingDescriptor *)descriptor
{
    if ([descriptor isKindOfClass:[MeetingFormat class]]) {
        return [self decoratorViewForMeetingFormat:(MeetingFormat*)descriptor];
    } else if ([descriptor isKindOfClass:[MeetingProgram class]]) {
        return [self decoratorViewForMeetingProgram:(MeetingProgram*)descriptor];
    } else if ([descriptor isKindOfClass:[Location class]]) {
        return [self decoratorViewForLocation:(Location*)descriptor];
    } else {
        DLog(@"<DEBUG> Unrecognized meeting descriptor type %@", [descriptor class]);
        return nil;
    }
}

+ (UIView*)decoratorViewForMeetingFormat:(MeetingFormat*)format
{
    AAMeetingFormatCircleDecorationView* circleView = [[AAMeetingFormatCircleDecorationView alloc] initWithFormat:format];
    return circleView;
}

+ (UIView*)decoratorViewForMeetingProgram:(MeetingProgram*)program
{
    AAMeetingFellowshipIcon* icon = [[AAMeetingFellowshipIcon alloc] init];
    icon.program = program;
    return icon;
}

+ (UIView*)decoratorViewForLocation:(Location*)location
{
    return nil;
}


+ (AAMeetingDescriptorTableViewCell*)tableView:(UITableView*)tableView meetingDescriptorCellForDescriptor:(MeetingDescriptor *)descriptor reuseIdentifier:(NSString *)reuseID
{
    return nil;
}

+ (AAMeetingDescriptorTableViewCell*)meetingDescriptorCellForDescriptor:(MeetingDescriptor *)descriptor
{
    return nil;
}




#pragma mark - Bar Button Items

+ (UIBarButtonItem*)stepsBarButtonItemForAction:(AABarButtonActionType)type
{
    switch (type) {
        case AABarButtonActionTypeAdd:
            return [self stepsAddBarButtonItem];
        
        case AABarButtonActionTypeCancel:
            return [self stepsCancelBarButtonItem];
            
        case AABarButtonActionTypeDone:
            return [self stepsDoneBarButtonItem];
            
        case AABarButtonActionTypeEdit:
            return [self stepsEditBarButtonItem];
    }
}

+ (UIBarButtonItem*)stepsAddBarButtonItem
{
    return [self stepsBarButtonItemWithType:UIBarButtonSystemItemAdd];
}

+ (UIBarButtonItem*)stepsCancelBarButtonItem
{
    return [self stepsBarButtonItemWithType:UIBarButtonSystemItemCancel];
}

+ (UIBarButtonItem*)stepsDoneBarButtonItem
{
    return [self stepsBarButtonItemWithType:UIBarButtonSystemItemDone];
}

+ (UIBarButtonItem*)stepsEditBarButtonItem
{
    return [self stepsBarButtonItemWithType:UIBarButtonSystemItemEdit];
}

+ (UIBarButtonItem*)stepsBarButtonItemWithType:(UIBarButtonSystemItem)type
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:nil action:nil];
}



@end
