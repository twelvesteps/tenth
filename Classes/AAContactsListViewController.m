//
//  AAContactsListViewController.m
//  Steps
//
//  Created by tom on 5/19/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import "AAContactsListViewController.h"
#import "AAContactViewController.h"
#import "AAUserDataManager.h"

@interface AAContactsListViewController () <UITableViewDelegate, UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, AAContactViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* contacts;

@property (strong, nonatomic) NSIndexPath* deletedContactIndexPath;

@end

@implementation AAContactsListViewController

#pragma mark - Viewcontroller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationController.delegate = self;
}


#pragma mark - Properties

- (NSArray*)contacts
{
    return [[AAUserDataManager sharedManager] fetchUserAAContacts];
}


#pragma mark - UI Events

- (IBAction)settingsButtonTapped:(UIBarButtonItem *)sender {
    
}


- (void)showDeleteActionSheet
{
    UIActionSheet* deleteSheet = [[UIActionSheet alloc] initWithTitle:@"Delete Contact"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Remove from phone"
                                                    otherButtonTitles:@"Remove from AA contacts", nil];
    [deleteSheet showInView:self.view];
}

#pragma mark - AAContactViewController Delegate

- (void)viewController:(AAContactViewController *)controller didExitWithAction:(AAContactEditAction)action
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Peoplepicker Delegate

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [[AAUserDataManager sharedManager] addContactForPersonRecord:person];
    Contact* contact = [[AAUserDataManager sharedManager] contactForPersonRecord:person];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self showContactViewControllerForContact:contact];
    
    [self.tableView reloadData];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Personview Delegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    return YES;
}


#pragma mark - Navigation Controller Delegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isEqual:self]) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    }
}


#pragma mark - Tableview Delegate and Datasource

#define AddContactSectionIndex 0

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == AddContactSectionIndex) {
        return 1;
    } else {
        return self.contacts.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == AddContactSectionIndex) {
        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddContactCell"];
        
        return cell;
    } else {
        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        
        cell.textLabel.text = [self titleForCellAtIndexPath:indexPath];
        
        return cell;
    }
}

- (NSString*)titleForCellAtIndexPath:(NSIndexPath*)indexPath
{
    Contact* contact = self.contacts[indexPath.row];
    return [contact.firstName stringByAppendingFormat:@" %@", contact.lastName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == AddContactSectionIndex) {
        [self showPeoplePickerViewController];
    } else {
        [self showContactViewControllerForContact:self.contacts[indexPath.row]];
    }
}

- (void)showPeoplePickerViewController
{
    ABPeoplePickerNavigationController* picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)showContactViewControllerForContact:(Contact*)contact
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == AddContactSectionIndex) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.deletedContactIndexPath = indexPath;
        [self showDeleteActionSheet];
    }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        self.deletedContactIndexPath = nil;
    } else {
        AAUserDataManager* manager = [AAUserDataManager sharedManager];
        Contact* contact = self.contacts[self.deletedContactIndexPath.row];
        
        // remove contact from address book
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            [manager removeContactFromUserAddressBook:contact];
        }
        
        // remove contact from database
        [manager removeAAContact:contact];
        
        [self.tableView reloadData];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.destinationViewController isKindOfClass:[AAContactViewController class]]) {
//        AAContactViewController* aacvc = (AAContactViewController*)segue.destinationViewController;
//        aacvc.delegate = self;
//        
//        if ([segue.identifier isEqualToString:@"setContact"]) {
//            if ([sender isKindOfClass:[UITableViewCell class]]) {
//                UITableViewCell* cell = (UITableViewCell*)sender;
//                NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
//                Contact* contact = self.contacts[indexPath.row];
//                aacvc.contact = contact;
//            }
//        }
//    }
//}


@end
