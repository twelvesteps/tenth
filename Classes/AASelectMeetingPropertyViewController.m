//
//  AASelectMeetingPropertyViewController.m
//  Steps
//
//  Created by Tom on 12/30/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AASelectMeetingPropertyViewController.h"
@interface AASelectMeetingPropertyViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSNumber* editingObj;

@end

@implementation AASelectMeetingPropertyViewController

#pragma mark - Lifecycle


#pragma mark - Properties

- (BOOL)isEditing
{
    if (!_editingObj) {
        _editingObj = [NSNumber numberWithBool:NO];
    }
    
    return _editingObj.boolValue;
}

- (void)setEditing:(BOOL)editing
{
    _editingObj = @(editing);
}

@end
