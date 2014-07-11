//
//  AAPeoplePickerViewController.h
//  Steps
//
//  Created by tom on 7/10/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@class AAPeoplePickerViewController;
@protocol AAPeoplePickerDelegate <NSObject>

- (void)peoplePickerNavigationController:(AAPeoplePickerViewController*)peoplePicker didSelectPeople:(NSArray*)people;
- (void)peoplePickerNavigationControllerDidCancel:(AAPeoplePickerViewController *)peoplePicker;

@end

@interface AAPeoplePickerViewController : UIViewController

@property (weak, nonatomic) id<AAPeoplePickerDelegate> peoplePickerDelegate;

@end
