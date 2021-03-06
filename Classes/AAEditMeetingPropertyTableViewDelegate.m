//
//  AAEditMeetingPropertyTableViewDelegate.m
//  Steps
//
//  Created by Tom on 12/30/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "AAEditMeetingPropertyTableViewDelegate.h"


@implementation AAEditMeetingPropertyTableViewDelegate

#pragma mark - Class Methods

- (instancetype)initWithPropertyName:(NSString*)name
{
    self = [super init];
    if (self) {
        _propertyName = name;
    }
    
    return self;
}


+ (instancetype)meetingPropertyDelegateWithPropertyName:(NSString *)name meeting:(Meeting *)meeting
{
    DLog(@"<DEBUG> Instantiating property delegate with name: %@", name);
    AAEditMeetingPropertyTableViewDelegate* delegate = nil;
    
    return delegate;
}

#pragma mark - Tableview Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    throwAbstractMethodException;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    throwAbstractMethodException;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    throwAbstractMethodException;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // no op
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end
