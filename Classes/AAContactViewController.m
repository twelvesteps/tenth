//
//  AAContactViewController.m
//  Steps
//
//  Created by tom on 5/26/14.
//  Copyright (c) 2014 spitzgoby LLC. All rights reserved.
//

#import "NBPhoneNumberUtil+AAAdditions.h"
#import "Phone.h"
#import "Email.h"
#import "AAContactNameAndImageTableViewCell.h"
#import "AAContactPhoneAndEmailTableViewCell.h"
#import "AAContactViewController.h"
#import "Contact+AAAdditions.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AAContactViewController () <UIAlertViewDelegate, ABPersonViewControllerDelegate, ABNewPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightToolbarButton;

@end

@implementation AAContactViewController

#pragma mark - ViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self needToLinkContact]) {
        self.rightToolbarButton.title = NSLocalizedString(@"Link Contact", @"link contact with phone contacts");
    } else if (!self.contact) {
        self.rightToolbarButton.title = NSLocalizedString(@"Create Contact", @"create new contact");
    } else {
        self.rightToolbarButton.title = NSLocalizedString(@"Edit", @"edit");
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.contact) {
        // should create a new AB contact first
        [self presentNewPersonViewControllerWithPerson:NULL];
    } else if ([self shouldShowPersonRecordNotFoundAlert]){
        [self showPersonRecordNotFoundAlert];
    }
}


#pragma mark - UI Events

- (void)updateContactDataWithPerson:(ABRecordRef)person
{
    if (person) {
        if (self.contact) {
            [[AAUserDataManager sharedManager] syncContact:self.contact withPersonRecord:person];
            self.newContact = NO;
            [self.tableView reloadData];
        } else if (self.newContact && person) {
            self.contact = [[AAUserDataManager sharedManager] createContactWithPersonRecord:person];
            self.newContact = NO;
            [self.tableView reloadData];
        }
    }
}

- (IBAction)rightToolbarButtonTapped:(UIBarButtonItem *)sender
{
    ABRecordRef person = [[AAUserDataManager sharedManager] fetchPersonRecordForContact:self.contact];
    if (person) {
        // use new person view controller to go straight to edit screen
        [self presentNewPersonViewControllerWithPerson:person];
    } else {
        [self presentPeoplePickerViewController];
    }
}

- (void)presentNewPersonViewControllerWithPerson:(ABRecordRef)person
{
    ABNewPersonViewController* abnpvc = [[ABNewPersonViewController alloc] init];
    abnpvc.displayedPerson = person;
    abnpvc.title = (person) ? @"" : NSLocalizedString(@"New Contact", @"New contact");
    abnpvc.newPersonViewDelegate = self;
    [self.navigationController pushViewController:abnpvc animated:YES];
}

- (void)presentPeoplePickerViewController
{
    ABPeoplePickerNavigationController* abppnc = [[ABPeoplePickerNavigationController alloc] init];
    abppnc.peoplePickerDelegate = self;
    [self presentViewController:abppnc animated:YES completion:nil];
}

- (BOOL)needToLinkContact
{
    if (!self.contact) {
        return NO;
    } else if (self.newContact) {
        return NO;
    } else {
        return [self.contact.needsABLink boolValue];
    }
}

- (BOOL)shouldShowPersonRecordNotFoundAlert
{
    return ([self needToLinkContact] && ![[AAUserDataManager sharedManager] fetchPersonRecordForContact:self.contact]);
}

- (void)showPersonRecordNotFoundAlert
{
    NSString* alertTitle = NSLocalizedString(@"Person Not Found",
                                             @"Selected contact could not be found in phone");
    NSString* alertMessage = NSLocalizedString(@"Please select the person associated with this contact",
                                               @"Select the phone contact that should be linked");
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"cancel")
                                          otherButtonTitles:NSLocalizedString(@"Select", @"Select"), nil];
    
    [alert show];
}

- (void)showAddressBookAccessDeniedAlert
{
    NSString* alertTitle = NSLocalizedString(@"Access Denied", @"access to contacts denied by user");
    NSString* alertMessage = NSLocalizedString(@"Change your privacy settings to allow Steps to access your phonebook",
                                               @"Instructions for allowing user phone book access");
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                          otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
    
    [alert show];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:NSLocalizedString(@"Person Not Found",
                                                           @"Selected contact could not be found in phone")]) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [self presentPeoplePickerViewController];
        }
    } else if ([alertView.title isEqualToString:NSLocalizedString(@"Access Denied", @"access to contacts denied by user")]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - ABViewController Delegates

#pragma mark ABPersonViewController
- (BOOL)personViewController:(ABPersonViewController *)personViewController
shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property
                  identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}

#pragma mark ABNewPersonViewController Delegate
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    if (person) { // user saved contact
        [self updateContactDataWithPerson:person];
        [self.navigationController popViewControllerAnimated:YES];
    } else { // user cancelled
        if (self.newContact) { // user didn't create contact, return to list view and remove contact
            [[AAUserDataManager sharedManager] removeAAContact:self.contact];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else { // user didn't edit contact, return to contact view
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - ABPeoplePickerNavigationController Delegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self updateContactDataWithPerson:person];

    [self dismissViewControllerAnimated:YES completion:^{
        if (self.newContact) {
            [self presentNewPersonViewControllerWithPerson:person];
        }
    }];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}


#pragma mark - UITableView Delegate and Datasource

#define CONTACT_NAME_CELL_SECTION       0

#define CONTACT_NAME_CELL_HEIGHT        112.0f
#define CONTACT_PHONE_EMAIL_CELL_HEIGHT 44.0f

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == CONTACT_NAME_CELL_SECTION) {
        return 1;
    } else {
        return self.contact.emails.count + self.contact.phones.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CONTACT_NAME_CELL_SECTION) {
        return CONTACT_NAME_CELL_HEIGHT;
    } else {
        return CONTACT_PHONE_EMAIL_CELL_HEIGHT;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CONTACT_NAME_CELL_SECTION) {
        return [self contactNameCell];
    } else {
        return [self phoneEmailCellForIndexPath:indexPath];
    }

}

- (UITableViewCell*)contactNameCell
{
    AAContactNameAndImageTableViewCell* cell = (AAContactNameAndImageTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"NameCell"];
    
    cell.contactNameLabel.text = self.contact.fullName;
    
    return cell;
}

- (UITableViewCell*)phoneEmailCellForIndexPath:(NSIndexPath*)indexPath
{
    AAContactPhoneAndEmailTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PhoneEmailCell"];
    NSSortDescriptor* sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    if (indexPath.row < self.contact.phones.count) {
        NSArray* phones = [[self.contact.phones allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];
        Phone* phone = phones[indexPath.row];
        
        cell.titleLabel.text = [phone.title stringByAppendingString:@":"];
        cell.descriptionLabel.text = phone.number;
        //cell.descriptionLabel.text = [[NBPhoneNumberUtil sharedInstance] formattedPhoneNumberFromNumber:phone.number];
    } else {
        NSArray* emails = [[self.contact.emails allObjects] sortedArrayUsingDescriptors:@[sortByTitle]];
        Email* email = emails[indexPath.row - self.contact.phones.count];
        
        cell.titleLabel.text = [email.title stringByAppendingString:@":"];
        cell.descriptionLabel.text = email.address;
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
